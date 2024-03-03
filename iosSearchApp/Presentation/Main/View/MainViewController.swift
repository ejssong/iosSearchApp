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
    
    let resultVC = ResultViewController()
    
    var layerView = MainLayerView()
    
    lazy var searchVC : UISearchController = {
        let search = UISearchController(searchResultsController: resultVC)
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        
        search.searchBar.placeholder = "검색어를 입력해 주세요"
        search.hidesNavigationBarDuringPresentation = true
        search.showsSearchResultsController = false
        return search
    }()
    
    var viewModel : MainViewModel!
    
    var disposeBag = DisposeBag()

    private var tableDataSource: RxTableViewSectionedReloadDataSource<SectionModel>!
    private var dataSource : RxCollectionViewSectionedAnimatedDataSource<SectionModel>!
     
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
        setConfigCollectionDataSource()
        setConfigTableDataSource()
        bind()
        resultVC.delegate = self
    }
    
    func setSearchView() {
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Search"
    }
    
    func setUI() {
        [layerView].forEach(view.addSubview(_:))
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
        
        viewModel.filterList
            .bind(to: layerView.tableView.rx.items(dataSource: tableDataSource))
            .disposed(by: disposeBag)

        viewModel.isSearching
            .distinctUntilChanged()
            .drive{ [weak self] value in
                self?.layerView.tableView.isHidden = !value
                self?.layerView.collectionView.isHidden = value
            }.disposed(by: disposeBag)
        
        viewModel.resultList
            .bind(to: resultVC.resultLayer.tableView.rx.items(dataSource: resultVC.dataSource))
            .disposed(by: disposeBag)

    }
    
    private func setConfigCollectionDataSource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { data, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell, let model = item as? SectionListModel else { return UICollectionViewCell() }
            cell.index = indexPath.row
            cell.label.text = model.value
            cell.delegate = self
            return cell
        }
        
        dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
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
                footer.delegate = self
            
                return footer
            default: return UICollectionReusableView()
            }
        }
    }

    private func setConfigTableDataSource() {
        tableDataSource = RxTableViewSectionedReloadDataSource<SectionModel> { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUpdateCell.identifier, for: indexPath) as? SearchUpdateCell, let model = item as? SectionListModel else { return UITableViewCell() }
            cell.setModel(of: model)
            return cell
        }
    }
}

