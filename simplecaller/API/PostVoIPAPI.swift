//
//  PostVoIPAPI.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation

protocol PostVoIPFetchable {
    func postWith(post: PostModel, completion: @escaping (Result<Post, APIError>) -> Void)
}

final class PostVoIPAPI: PostVoIPFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func postWith(post: PostModel, completion: @escaping (Result<Post, APIError>) -> Void) {
        networkManager.networkPost(post: post, completion: completion)
    }
}
