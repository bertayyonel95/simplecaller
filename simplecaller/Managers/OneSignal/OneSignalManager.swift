//
//  OneSignalManager.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation
import OneSignalFramework

final class OneSignalManager {
    
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    static let shared = OneSignalManager()
    private init() {
        OneSignal.initialize(Constants.API.key, withLaunchOptions: launchOptions)
        OneSignal.User.pushSubscription.optIn()
    }
    
    func logIin(with username: String) {
        OneSignal.login(username)
    }
}
