//
//  WebViewCoordinator.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

protocol WebViewCoordinatorDependencies {
    func makeWebViewController(url: String) -> WebViewController

}

final class WebViewCoordinator {
    private weak var navigation: UINavigationController?
    private let dependencies: WebViewCoordinatorDependencies
    
    init(navigation: UINavigationController, dependencies: WebViewCoordinatorDependencies) {
        self.navigation = navigation
        self.dependencies = dependencies
    }
    
    func moveToWebView(_ url: String) {
        let webVC = dependencies.makeWebViewController(url: url)
        
        navigation?.pushViewController(webVC, animated: true)
    }
}
