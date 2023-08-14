//
//  AgoraManager.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation
import AVFoundation
import AgoraRtcKit

final class AgoraManager: NSObject {
    var agoraEngine: AgoraRtcEngineKit!
    var tokenAPI: TokenFetchable = DependencyContainer.shared.tokenAPI()
    var token: String = .empty
    override init() {
        super.init()
        initializeAgoraEngine()
    }
    
    deinit {
        cleanUp()
    }

    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        config.appId = Constants.appID
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    
    func joinChannel(with channelName: String) async {
        let option = AgoraRtcChannelMediaOptions()
        option.clientRoleType = .broadcaster
        option.channelProfile = .communication

        let group = DispatchGroup()
        let requestModel = TokenRequestModel(with: channelName, and: "0")
        var tokenP: String = .empty
        group.enter()
        tokenAPI.retrieveToken(request: requestModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print("-------->" + success.rtcToken)
                tokenP = success.rtcToken
                group.leave()
            case .failure(let error):
                print(error.localizedDescription)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.agoraEngine.joinChannel(
                byToken: tokenP, channelId: channelName, uid: 0, mediaOptions: option,
                joinSuccess: { (channel, uid, elapsed) in
                    print(elapsed)
                }
            )
        }
        print("CALL INFO ------> token: \(token), channelName: \(channelName)")
    }
    
    func leaveChannel() {
        let result = agoraEngine.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if result == 0 {  }
    }
    
    func cleanUp() {
        leaveChannel()
        DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
    }
}

extension AgoraManager: AgoraRtcEngineDelegate {
}
