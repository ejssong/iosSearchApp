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
import Toast

class MainViewController: UIViewController {
    
    let resultVC = ResultViewController()
    
    var layerView = MainLayerView()
    
    lazy var searchVC : UISearchController = {
        let search = UISearchController(searchResultsController: resultVC)
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "검색어를 입력해 주세요"
        search.hidesNavigationBarDuringPresentation = true
        return search
    }()
    
    var viewModel : MainViewModel!
    
    var disposeBag = DisposeBag()

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
        itemSelectBind()
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
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
        }
    }
    
    func bind() {
        viewModel.recentSearchList
            .bind(to: layerView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.filterList
            .bind(to: resultVC.viewModel.output.filterList )
            .disposed(by: disposeBag)
        
        viewModel.resultList
            .bind(to: resultVC.viewModel.output.resultList )
            .disposed(by: disposeBag)
    
        viewModel.searchType
            .bind(to: resultVC.viewModel.output.searchType )
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: resultVC.viewModel.output.isLoading )
            .disposed(by: disposeBag)
        
        viewModel.rateLimit
            .bind(to: resultVC.viewModel.output.rateLimit )
            .disposed(by: disposeBag)
        
        viewModel.isComplete
            .bind(to: resultVC.viewModel.output.isComplete )
            .disposed(by: disposeBag)
        
        viewModel.isError
            .bind(to: resultVC.viewModel.output.isError )
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .withUnretained(self)
            .subscribe{ owner, value in
                let topVC = UIApplication.getMostTopViewController()
                topVC?.view.makeToast(value)
            }.disposed(by: disposeBag)
    }
    
    private func setConfigCollectionDataSource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { data, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell, let model = item as? SectionListModel else { return UICollectionViewCell() }
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
    
    private func itemSelectBind() {
        Observable.of(resultVC.resultLayer.recentTableView.rx.modelSelected(SectionListModel.self), layerView.collectionView.rx.modelSelected(SectionListModel.self))
            .merge()
            .subscribe{[weak self] model in
                guard let self = self else { return }
                //1.텍스트 필드 입력
                self.searchVC.searchBar.text = model.value
                self.searchVC.isActive       = true
                //2.리스트 조회
                self.viewModel.moveToResult(of: self.searchVC.searchBar.text ?? "")
                //3.결과 창 보여주기
                self.searchVC.showsSearchResultsController = true
                //4.키보드 내리기
                self.searchVC.searchBar.endEditing(true)
            }.disposed(by: disposeBag)
    }
}

