//
//  PostModel.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation
import Alamofire

class PostModel {
    // MARK: Properties
    var senderID: String = .empty
    var receiverID: String
    var channelID: String
    var path: String {
        .empty
    }
    var headers: HTTPHeaders {
        [
            "accept": "application/json",
            "Authorization": "Basic " + Constants.API.restAPIKey,
            "content-type": "application/json"
        ]
    }
    
    var parameters: Parameters = [:]

    var endpoint: String {
        Constants.API.postURL
    }
    
    init(senderID: String, receiverID: String, channelID: String) {
        self.senderID = senderID
        self.receiverID = receiverID
        self.channelID = channelID
        self.parameters = [
            "app_id": Constants.API.key,
            "apns_push_type_override": "voip",
            "contents": [
                "en": "\(senderID)/\(channelID)"
            ],
            "include_external_user_ids": [
                "\(receiverID)"
            ]
        ]
    }
}

// MARK: - Helpers
extension PostModel {
    
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
