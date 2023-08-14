//
//  LoginRouter.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import Foundation
import UIKit

protocol LoginRouting {
    var loginController: LoginViewController? { get set }
    func navigateToHome()
}

class LoginRouter: LoginRouting {
    var loginController: LoginViewController?
    func navigateToHome() {
        let homeController = HomeBuilder.build()
        homeController.modalPresentationStyle = .overFullScreen
        loginController?.present(homeController, animated: true)
    }
}
