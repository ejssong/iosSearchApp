//
//  AppDIContainer.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit

final class AppDIContainer {
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator  {
        let mainDI = MainDIContainer()
        return mainDI.makeMainCoordinator(navigation: navigationController)
    }
}


