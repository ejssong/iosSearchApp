//
//  WebDIContainer.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

class WebDIContainer: WebViewCoordinatorDependencies {
    
    func makeWebCoordinator(navigationController: UINavigationController) -> WebViewCoordinator  {
        return WebViewCoordinator(navigation: navigationController, dependencies: self)
    }
    
    func makeWebViewController(url: String) -> WebViewController {
        let webVM = makeWebViewModel(url: url)
        return WebViewController.create(with: webVM)
    }
    
    func makeWebViewModel(url: String) -> WebViewModel {
        return DefaultWebViewModel(url: url)
    }
}
