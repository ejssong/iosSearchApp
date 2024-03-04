//
//  MainVC+Search.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import UIKit

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.moveToResult(of: searchBar.text ?? "")
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        viewModel.didSearchUpdate(of: text)
    }
}
