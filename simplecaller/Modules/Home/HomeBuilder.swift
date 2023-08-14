//
//  HomeBuilder.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import Foundation

class HomeBuilder {
    static func build() -> HomeController {
        let dependencyContainer = DependencyContainer.shared
        let homeRouter = HomeRouter()
        let homeViewModel = HomeViewModel(
            homeRouter: homeRouter,
            externalIDAPI: dependencyContainer.externalIDAPI(),
            tokenAPI: dependencyContainer.tokenAPI(),
            postVoIP: dependencyContainer.postVoIPAPI()
        )
        let homeController = HomeController(viewModel: homeViewModel)
        homeRouter.homeController = homeController
        return homeController
    }
}
