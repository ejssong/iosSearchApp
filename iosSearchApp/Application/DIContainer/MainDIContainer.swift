//
//  MainDIContainer.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit

final class MainDIContainer {
    func makeMainCoordinator(navigation: UINavigationController) -> MainCoordinator {
        return MainCoordinator(navigation: navigation, dependencies: self)
    }
    
    func makeMainViewModel(actions: MainViewModelActions) -> MainViewModel {
        let mainUseCase = makeMainUseCase()
        return DefaultMainViewModel(usecase: mainUseCase, actions: actions)
    }
    
    func makeMainUseCase() -> MainUseCase {
        return DefaultMainUseCase(repository: makeMainRepository())
    }
    
    func makeMainRepository() -> MainRepositoryProtocol {
        return DefaultMainRepository()
    }
}

extension MainDIContainer: MainCoordinatorDependencies {
    
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController {
        let mainVM = makeMainViewModel(actions: actions)
        return MainViewController.create(with: mainVM)
    }
    
    func makeWebViewCoordinator(navigationController: UINavigationController) -> WebViewCoordinator {
        let WebDI = WebDIContainer()
        return WebDI.makeWebCoordinator(navigationController: navigationController)
    }
}
