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
    func makeWebViewCoordinator(navigationController: UINavigationController) -> WebViewCoordinator
}

final class MainCoordinator {
    private weak var navigation: UINavigationController?
    private let dependencies: MainCoordinatorDependencies
    
    init(navigation: UINavigationController, dependencies: MainCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
    
    func moveToMain() {
        let actions = MainViewModelActions(moveToMemo: moveToWebView)
        let mainVC = dependencies.makeMainViewController(actions: actions)
        navigation?.pushViewController(mainVC, animated: false)
    }
    
    func moveToWebView(_ url: String) {
        guard let navigation = navigation else { return }
        let coordinator = dependencies.makeWebViewCoordinator(navigationController: navigation)
        coordinator.moveToWebView(url)
    }
}
