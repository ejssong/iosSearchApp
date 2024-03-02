//
//  MainViewController.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    var layerView = MainLayerView()
    
    var viewModel : MainViewModel!
    
    var disposeBag = DisposeBag()
    
    private var dataSource : RxCollectionViewSectionedReloadDataSource<SectionModel>!
     
    static func create(with viewModel: MainViewModel) -> MainViewController {
        let mainVC = MainViewController()
        mainVC.viewModel = viewModel
        return mainVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        commonInit()
    }
    
    func commonInit() {
        setUI()
        setConstraint()
        setSearchView()
        setConfigDataSource()
        bind()
    }
    
    func setSearchView() {
        let autoCompleteVC = AutoCompleteViewController()
        let search = UISearchController(searchResultsController: autoCompleteVC)
        search.searchBar.delegate = self
        search.searchBar.placeholder = "검색어를 입력해 주세요"
        search.hidesNavigationBarDuringPresentation = true
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Search"
    }
    
    func setUI() {
        view.addSubview(layerView)
    }
    
    func setConstraint() {
        layerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.recentSearchList
            .bind(to: layerView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setConfigDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell, let model = item as? SectionListModel else { return UICollectionViewCell() }
            cell.label.text = model.value
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.identifier, for: indexPath) as? CustomHeaderView else { return UICollectionReusableView() }
                let title = dataSource.sectionModels[indexPath.section].header
                header.bind(title: title)
                return header
            case UICollectionView.elementKindSectionFooter:
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomFooterView.identifier, for: indexPath) as? CustomFooterView else { return UICollectionReusableView() }
                let title = dataSource.sectionModels[indexPath.section].footer
                footer.bind(title: title)
                return footer
            default: return UICollectionReusableView()
            }
        })
    }
}

