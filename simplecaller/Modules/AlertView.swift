//
//  AlertView.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import UIKit

// MARK: - ErrorMessageManager
final class AlertHandler {
    
    // MARK: Typealias
    typealias ConfirmButtonHandler = () -> Void
    typealias CancelButtonHandler = () -> Void
    
    // MARK: Properties
    static let shared = AlertHandler()
    var confirmButtonHandler: ConfirmButtonHandler?
    var loginButtonHandler: ConfirmButtonHandler?
    var cancelButtonHandler: CancelButtonHandler?
    
    // MARK: Init
    private init() {
    }
}

// MARK: - Helpers
extension AlertHandler {
    
    // MARK: Helpers
    /// Presents an alert view on the current view controller with given actions and message.
    ///
    /// - Parameters:
    ///    - errorMessage: view controller that the alert will be presented.
    ///    - in: view in which the alert will be shown.
    ///    - with: title of the alert window.
    ///    - actionType: an array with possible types of actions. (see ActionButtonType for more deatils)
    func show(errorMessage: String, in viewController: UIViewController, with title: String) {
        let alertController = UIAlertController(title: "Enter Username", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter username here"
        }
        let confirmAction = UIAlertAction(
            title: title,
            style: .default) { _ in
            self.confirmButtonHandler?()
        }
        alertController.addAction(confirmAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
