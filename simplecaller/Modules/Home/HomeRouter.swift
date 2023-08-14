//
//  HomeRouter.swift
//  simplecaller
//
//  Created by Bertay Yönel on 12.08.2023.
//

import UIKit

protocol HomeRouting {
    var homeController: HomeController? { get set }
}

class HomeRouter: HomeRouting {
    var homeController: HomeController?
    
}
