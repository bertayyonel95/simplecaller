//
//  TokenAPI.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation

protocol TokenFetchable {
    func retrieveToken(request: TokenRequestModel, completion: @escaping (Result<Token, APIError>) -> Void)
}

final class TokenAPI: TokenFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveToken(request: TokenRequestModel, completion: @escaping (Result<Token, APIError>) -> Void) {
        networkManager.networkRequest(request: request, completion: completion)
    }
}
