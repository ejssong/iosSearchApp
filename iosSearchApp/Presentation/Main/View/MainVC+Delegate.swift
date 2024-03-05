//
//  MainVC+Bind.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

extension MainViewController: RecentSearchDelegate {
    func delete(_ label: String) {
        viewModel.didTapRemoveKeyword(of: label)
    }
}

extension MainViewController: CustomFooterDelegate {
    func didTapRemove() {
        viewModel.didTapRemoveAll()
    }
}

extension MainViewController : ResultViewDelegate {
    func hideSearchVC(with value: Bool) {
        searchVC.showsSearchResultsController = !value
    }
    
    func moveToLink(of url: String) {
        viewModel.moveToWebView(url)
    }
    
    func nextPageScroll() {
        viewModel.nextPageScroll()
    }
    
}
