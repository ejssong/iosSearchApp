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
