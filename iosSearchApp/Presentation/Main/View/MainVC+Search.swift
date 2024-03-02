//
//  MainVC+Search.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import UIKit

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button click")
        viewModel.moveToResult(of: searchBar.text ?? "")
    }
}

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
