//
//  RegisterVoIPToken.swift
//  simplecaller
//
//  Created by Bertay Yönel on 14.08.2023.
//

import Foundation
import Alamofire

class RegisterVoIPToken {
    // MARK: Properties
    var userID: String = .empty
    var voipToken: String
    var path: String {
        .empty
    }
    let headers: HTTPHeaders = [
      "accept": "application/json",
      "Content-Type": "application/json"
    ]
    
    var parameters: Parameters = [:]

    var endpoint: String {
        "https://onesignal.com/api/v1/players"
    }
    
    init(userID: String, voipToken: String) {
        self.userID = userID
        self.voipToken = voipToken
        self.parameters = [
            "app_id": Constants.API.key,
            "identifier": "\(voipToken)",
            "device_type": 0,
            "external_id": "\(userID)",
            "test_type": 1
        ]
    }
}

// MARK: - Helpers
extension RegisterVoIPToken {
    
    /// Generates a request for the network call
    ///
    /// - Returns: A URL request to be used to make a network call.
    func generatePost() {
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response() { response in
            switch response.result {
            case .success(let data):
                print(data?.description)
            case .failure(let error):
                print(error)
            }
            print(response.response)
        }
    }
}
