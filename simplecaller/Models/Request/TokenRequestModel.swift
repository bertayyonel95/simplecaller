//
//  TokenRequestModel.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation

final class TokenRequestModel: RequestModel {
    var room: String
    var userID: String
    
    init(with room: String, and userID: String) {
        self.room = room
        self.userID = userID
    }
    
    override var endpoint: String {
        Constants.API.tokenURL
    }
    
    override var path: String {
        var path = super.path
        path = "\(room)/publisher/uid/\(userID)"
        return path
    }
}
