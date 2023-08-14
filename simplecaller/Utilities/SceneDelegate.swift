//
//  SceneDelegate.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        var controller: UIViewController = UIViewController()
        do {
            let userID = try UserDefaultsManager.shared.getObject(forKey: "userID", castTo: String.self)
            OneSignalManager.shared.logIin(with: userID)
            controller = HomeBuilder.build()
        } catch {
            controller = LoginBuilder.build()
        }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }
}
