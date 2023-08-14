//
//  LoginBuilder.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation

class LoginBuilder {
    static func build() -> LoginViewController {
        let dependencyContainer = DependencyContainer.shared
        let loginRouter = LoginRouter()
        let loginViewModel = LoginViewModel(
            loginRouter: loginRouter,
            externalIDAPI: dependencyContainer.externalIDAPI()
        )
        let loginController = LoginViewController(viewModel: loginViewModel)
        loginRouter.loginController = loginController
        return loginController
    }
}
