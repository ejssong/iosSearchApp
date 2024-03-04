//
//  ResultViewController.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import RxCocoa

protocol ResultViewDelegate: AnyObject {
    func moveToLink(of url: String)
    func nextPageScroll()
}

class ResultViewController: UIViewController {
    
    var resultLayer = ResultLayerView() //결과 뷰
    
    let indicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
    }
    
    var filterDataSource: RxTableViewSectionedReloadDataSource<SectionModel>!
    
    var resultDataSource: RxTableViewSectionedReloadDataSource<ResultResponseDTO>!
    
    var searchType: BehaviorRelay<SearchType> = .init(value: .isEmtpy)
    
    var filterList : BehaviorRelay<[SectionModel]> = .init(value: [])
    
    var resultList : BehaviorRelay<[ResultResponseDTO]> = .init(value: [])
    
    var isLoading : BehaviorRelay<Bool> = .init(value: false)
    
    weak var delegate : ResultViewDelegate?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    func commonInit() {
        setUI()
        setConstraint()
        setConfigTableDataSource()
        setConfigRecentTableDataSource()
        bind()
    }
    
    func setUI() {
        [resultLayer, indicatorView].forEach(view.addSubview(_:))
    }
    
    func setConstraint() {
        resultLayer.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    private func setConfigTableDataSource() {
        resultDataSource = RxTableViewSectionedReloadDataSource<ResultResponseDTO> { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else { return UITableViewCell() }
            cell.setModel(of: item)
            return cell
        }
        
        resultDataSource.titleForHeaderInSection = { dataSource, index in
            let totalCnt =  dataSource.sectionModels[index].totalCnt
            return "\(totalCnt)개 저장소"
        }
    }
    
    private func setConfigRecentTableDataSource() {
        filterDataSource = RxTableViewSectionedReloadDataSource<SectionModel> { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUpdateCell.identifier, for: indexPath) as? SearchUpdateCell, let model = item as? SectionListModel else { return UITableViewCell() }
            cell.setModel(of: model)
            return cell
        }
    }
    
    func bind() {
        isLoading
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, type) in
                type ? owner.indicatorView.startAnimating() : owner.indicatorView.stopAnimating()
                
            }).disposed(by: disposeBag)
        
        searchType
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, type) in
                owner.resultLayer.tableView.isHidden = type != .isComplete
                owner.resultLayer.recentTableView.isHidden = type != .isSearching
            }).disposed(by: disposeBag)
        
        filterList
            .bind(to: resultLayer.recentTableView.rx.items(dataSource: filterDataSource))
            .disposed(by: disposeBag)
        
        resultList
            .bind(to: resultLayer.tableView.rx.items(dataSource: resultDataSource))
            .disposed(by: disposeBag)
        
        resultLayer.tableView.rx.modelSelected(ResultItem.self)
            .withUnretained(self)
            .subscribe(onNext: { (owner, item ) in
                guard let url = item.owner?.url else { return }
                owner.delegate?.moveToLink(of: url)
            }).disposed(by: disposeBag)
        
        resultLayer.tableView.rx.prefetchRows
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (owner, item) in
                owner.delegate?.nextPageScroll()
            }).disposed(by: disposeBag)
     }
    
}
