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
        viewModel.moveToResult(of: searchBar.text ?? "", isInitial: true)
        searchVC.showsSearchResultsController = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didSearchCancel()
        searchVC.showsSearchResultsController = false
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        text.isEmpty ? viewModel.didSearchCancel() : viewModel.didSearchUpdate(of: text)
    }
}
