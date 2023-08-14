//
//  CallerIDRequestModel.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

final class ExternalIDRequestModel: RequestModel {
    var externalID: String
    
    init(with externalID: String) {
        self.externalID = externalID
    }
    
    override var path: String {
        var path = super.path
        path = "users/by/external_id/\(externalID)/identity"
        return path
    }
}
