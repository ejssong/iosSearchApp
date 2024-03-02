//
//  UINavigation+.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit

extension UINavigationController {
    static func defaultNavigaiton() -> UINavigationController {
        let navigation = UINavigationController()
        navigation.hidesBottomBarWhenPushed = true
        navigation.setToolbarHidden(true, animated: false)
        navigation.setNavigationBarHidden(false, animated: false)
        navigation.navigationBar.prefersLargeTitles = true 
        return navigation
    }
    
    @objc public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
