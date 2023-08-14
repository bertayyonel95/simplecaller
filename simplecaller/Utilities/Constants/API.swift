//
//  API.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

extension Constants {
    class API {
        static let key = "0e458dac-ea8e-41b3-bd0f-d26b477cca72"
        static let restAPIKey = "ZjkwNWMwNmYtODA0Mi00ZDEyLWFjZmMtZTdkYzdhNGM4MDVk"
        static let url = "https://onesignal.com/api/v1/apps/" + key + "/"
        static let tokenURL = "https://simplecaller-token-generator-bbdf5bda9923.herokuapp.com/rtc/"
        static let postURL = "https://onesignal.com/api/v1/notifications"
    }
}
