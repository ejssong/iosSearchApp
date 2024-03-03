//
//  SearchResultUpdateView.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
//
//class SearchResultUpdateView: UITableViewController, UISearchResultsUpdating {
//
//    var filterList : BehaviorRelay<[SectionListModel]> = .init(value: [])
//
//    var disposeBag = DisposeBag()
//
//    convenience init() {
//        self.init()
//        view.backgroundColor = .systemPink
//        bind()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text?.lowercased(),
//              let list = UserDefaultsManager.recentList else  { return }
//
//        let value = list.filter{ $0.value.lowercased().contains(text) }
//        tableView.isHidden = false
//        filterList.accept(value)
//    }
//
//    func bind() {
//        filterList
//            .bind(to: tableView.rx.items(cellIdentifier: SearchUpdateCell.identifier, cellType: SearchUpdateCell.self)) { [weak self]  row, model, cell in
//                guard let _ = self else { return }
//
//                cell.setModel(of: model)
//
//            }.disposed(by: disposeBag)
//    }
//
//}
