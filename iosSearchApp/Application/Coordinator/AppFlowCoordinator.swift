//
//  AppFlowCoordinator.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
    var navigation: UINavigationController
    private let appDIContainer : AppDIContainer
    
    init(navigation: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigation = navigation
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let mainCoordinator = appDIContainer.makeMainCoordinator(navigationController: navigation)
        mainCoordinator.moveToMain()
    }
}
