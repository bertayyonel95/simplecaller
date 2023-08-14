//
//  CallerIDAPI.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

protocol ExternalIDFetchable {
    func retrieveByExternalID(request: ExternalIDRequestModel, completion: @escaping (Result<User, APIError>) -> Void)
}

final class ExternalIDAPI: ExternalIDFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByExternalID(request: ExternalIDRequestModel, completion: @escaping (Result<User, APIError>) -> Void) {
        networkManager.networkRequest(request: request, completion: completion)
    }
}
