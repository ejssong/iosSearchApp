//
//  MainVC+Bind.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

extension MainViewController: RecentSearchDelegate {
    func deleteIndex(_ index: Int) {
        viewModel.didTapRemoveKeyword(of: index)
    }
}

extension MainViewController: CustomFooterDelegate {
    func didTapRemove() {
        viewModel.didTapRemoveAll()
    }
}
