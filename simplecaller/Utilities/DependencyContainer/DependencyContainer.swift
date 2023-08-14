//
//  DependencyContainer.swift
//  findfood
//
//  Created by Bertay Yönel on 24.07.2023.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    private init() {}
    
    func networkManager() -> Networking {
        return NetworkManager(session: .shared)
    }
    
    func externalIDAPI() -> ExternalIDFetchable {
        return ExternalIDAPI(networkManager: self.networkManager())
    }
    
    func tokenAPI() -> TokenFetchable {
        return TokenAPI(networkManager: self.networkManager())
    }
    
    func postVoIPAPI() -> PostVoIPFetchable {
        return PostVoIPAPI(networkManager: self.networkManager())
    }
    
    func callManager() -> CallManager {
        return CallManager()
    }
    
    func providerDelegate() -> ProviderDelegate {
        return ProviderDelegate(callManager: self.callManager())
    }

}
