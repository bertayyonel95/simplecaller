//
//  ProviderDelegate.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import AVFoundation
import CallKit

class ProviderDelegate: NSObject {
  private let callManager: CallManager
  private let provider: CXProvider
    let agoraManager = AgoraManager()
    var channelID: String = .empty
  
  init(callManager: CallManager) {
    self.callManager = callManager
    provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
    super.init()
    provider.setDelegate(self, queue: nil)
  }
  
  static var providerConfiguration: CXProviderConfiguration = {
    let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
    providerConfiguration.supportsVideo = true
    providerConfiguration.maximumCallsPerCallGroup = 1
    providerConfiguration.supportedHandleTypes = [.phoneNumber]
    return providerConfiguration
  }()
  
  func reportIncomingCall(
    uuid: UUID,
    handle: String,
    hasVideo: Bool = false,
    channelID: String,
    completion: ((Error?) -> Void)?
  ) {
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
    update.hasVideo = hasVideo
      self.channelID = channelID
    
    provider.reportNewIncomingCall(with: uuid, update: update) { error in
      if error == nil {
        let call = Call(uuid: uuid, handle: handle)
        self.callManager.add(call: call)
      }
      
      completion?(error)
    }
  }
}

// MARK: - CXProviderDelegate
extension ProviderDelegate: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
      stopAudio()
      for call in callManager.calls {
        call.end()
      }
      callManager.removeAllCalls()
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    Task {
        await agoraManager.joinChannel(with: channelID)
    }
    call.answer()
    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
    
  }
  
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        agoraManager.leaveChannel()
        stopAudio()
        call.end()
        action.fulfill()
        callManager.remove(call: call)
  }
  
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call(uuid: action.callUUID, outgoing: true, handle: action.handle.value)
        call.connectedStateChanged = { [weak self, weak call] in
            guard
                let self = self,
                let call = call
            else {
                return
            }
            if call.connectedState == .pending {
                self.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
            } else if call.connectedState == .complete {
                self.provider.reportOutgoingCall(with: call.uuid, connectedAt: nil)
            }
        }
        call.start { [weak self, weak call] success in
            guard
                let self = self,
                let call = call
            else {
                return
            }
            if success {
            action.fulfill()
            self.callManager.add(call: call)
            } else {
            action.fail()
            }
        }
    }
}
