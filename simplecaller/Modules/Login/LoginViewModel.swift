//
//  LoginViewModel.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation

// MARK: - HomeViewModelInput
protocol LoginViewModelInput {
    // MARK: Properties
    var output: LoginViewModelOutput? { get set }
    func confirmPressed(with username: String)
    func navigateToHome()
}

// MARK: - HomeViewModelOutput
protocol LoginViewModelOutput: AnyObject {
    func login(_ usernameTaken: Bool)
}

final class LoginViewModel: NSObject, LoginViewModelInput {
    private let loginRouter: LoginRouting
    private let externalIDAPI: ExternalIDFetchable
    weak var output: LoginViewModelOutput?
    private var exists: Bool = false
    
    init(loginRouter: LoginRouting, externalIDAPI: ExternalIDFetchable) {
        self.loginRouter = loginRouter
        self.externalIDAPI = externalIDAPI
    }
    
    func confirmPressed(with username: String) {
        let requestModel = ExternalIDRequestModel(with: username)
        let group = DispatchGroup()
        if username.isEmpty { return }
        LoadingManager.shared.show()
        group.enter()
        externalIDAPI.retrieveByExternalID(request: requestModel) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                LoadingManager.shared.hide()
                group.leave()
                output?.login(true)
                self.exists = true
                return
            case .failure(_):
                LoadingManager.shared.hide()
                OneSignalManager.shared.logIin(with: username)
                exists = false
                group.leave()
                do {
                    try UserDefaultsManager.shared.setObject(username, forKey: "userID")
                } catch {
                }
                let register = RegisterVoIPToken.init(userID: username, voipToken: UserDefaultsManager.shared.voipToken ?? .empty)
                register.generatePost()
            }
        }
        group.notify(queue: .main) {
            if !self.exists {
                self.loginRouter.navigateToHome()
            }
        }
    }
    
    func navigateToHome() {
        loginRouter.navigateToHome()
    }
}
