//
//  UIApplication+.swift
//  iosSearchApp
//
//  Created by ejsong on 3/6/24.
//

import Foundation
import UIKit

extension UIApplication {

    public class func getMostTopViewController(base: UIViewController? = nil) -> UIViewController? {

        var baseVC: UIViewController?
        if base != nil {
            baseVC = base
        }
        else {
            if #available(iOS 13, *) {
                baseVC = (UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap { $0.windows }
                            .first { $0.isKeyWindow })?.rootViewController
            }
            else {
                baseVC = UIApplication.shared.keyWindow?.rootViewController
            }
        }
        
        if let naviController = baseVC as? UINavigationController {
            return getMostTopViewController(base: naviController.visibleViewController)

        } else if let tabbarController = baseVC as? UITabBarController, let selected = tabbarController.selectedViewController {
            return getMostTopViewController(base: selected)

        } else if let presented = baseVC?.presentedViewController {
            return getMostTopViewController(base: presented)
        }
        return baseVC
    }
}
