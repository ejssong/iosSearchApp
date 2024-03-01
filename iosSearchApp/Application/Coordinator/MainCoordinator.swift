//
//  MainCoordinator.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit

protocol MainCoordinatorDependencies {
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController
}

final class MainCoordinator {
    private weak var navigation: UINavigationController?
    private let dependencies: MainCoordinatorDependencies
    
    init(navigation: UINavigationController, dependencies: MainCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
    
    func moveToMain() {
        let actions = MainViewModelActions()
        let mainVC = dependencies.makeMainViewController(actions: actions)
        navigation?.pushViewController(mainVC, animated: false)
    }
}
