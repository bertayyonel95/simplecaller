//
//  AppDelegate.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import UIKit
import OneSignalFramework
import PushKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let callManager = CallManager()
    let agoraManager = AgoraManager()
    var providerDelegate: ProviderDelegate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let oneSignal = OneSignalManager.shared
        oneSignal.launchOptions = launchOptions
        self.voipRegistration()
        providerDelegate = ProviderDelegate(callManager: callManager)
        return true
    }
    
    // Register for VoIP notifications
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    func displayIncomingCall(
      uuid: UUID,
      handle: String,
      hasVideo: Bool = false,
      channelID: String,
      completion: ((Error?) -> Void)?
    ) {
      providerDelegate.reportIncomingCall(
        uuid: uuid,
        handle: handle,
        hasVideo: hasVideo,
        channelID: channelID,
        completion: completion)
    }
}

extension AppDelegate: PKPushRegistryDelegate {
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        UserDefaultsManager.shared.voipToken = deviceToken
        print("pushRegistry -> deviceToken :\(deviceToken)")
    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print(payload.dictionaryPayload)
        self.receiveIncomingPush(payload: payload, for: type)
        
        guard type == .voIP else { return }
        
    }
    
    func receiveIncomingPush(payload: PKPushPayload, for type: PKPushType) {
        print("did receiving  incoming Payload")
        guard type == .voIP else {
            return
        }
        var customString: String = .empty
        if let customData = payload.dictionaryPayload["aps"] as? [String:Any]{
        //Handle your incomming VoIP notification here
            let values = customData.values
            customData.forEach { key, value in
                if key == "alert" {
                    customString = value as! String
                }
            }
            print(customString)
        }
        let components = customString.components(separatedBy: "/")
        let callerName = components[0]
        let channelName = components[1]
        
        displayIncomingCall(uuid: UUID(), handle: callerName, channelID: channelName) { error in
        }
    }
}
