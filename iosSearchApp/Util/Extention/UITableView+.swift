//
//  UITableView+.swift
//  iosSearchApp
//
//  Created by ejsong on 3/5/24.
//

import Foundation
import UIKit

extension UITableView {
    func isLast(for indexPath: IndexPath) -> Bool {

        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}
