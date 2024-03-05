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
    func hideSearchVC(with value: Bool)
}

class ResultViewController: UIViewController {
    
    var resultLayer = ResultLayerView() //결과 뷰
    
    let indicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
    }
    
    var filterDataSource: RxTableViewSectionedReloadDataSource<SectionModel>!
    
    var resultDataSource: RxTableViewSectionedReloadDataSource<ResultResponseDTO>!
    
    weak var delegate : ResultViewDelegate?
    
    var viewModel = ResultViewModel()
    
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
        resultLayer.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.output.rateLimit
            .withUnretained(self)
            .subscribe{ owner, model in
                guard let model = model else { return }
                owner.resultLayer.rateLimiView.isHidden = false
                owner.resultLayer.rateLimiView.setUI(model)
            }.disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe{ owner, type in
                type ? owner.indicatorView.startAnimating() : owner.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
        
        Observable.of( viewModel.output.isComplete, viewModel.output.isError )
            .merge()
            .withUnretained(self)
            .subscribe{ owner, type in
                owner.indicatorView.stopAnimating()
                owner.resultLayer.tableView.tableFooterView = nil
            }.disposed(by: disposeBag)
        
        viewModel.output.searchType
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe{ owner, type in
                owner.resultLayer.rateLimiView.isHidden = true
                owner.delegate?.hideSearchVC(with: type == .isEmtpy)
                owner.resultLayer.tableView.isHidden = type != .isComplete
                owner.resultLayer.recentTableView.isHidden = type != .isSearching
            }.disposed(by: disposeBag)
        
        viewModel.output.filterList
            .bind(to: resultLayer.recentTableView.rx.items(dataSource: filterDataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.resultList
            .bind(to: resultLayer.tableView.rx.items(dataSource: resultDataSource))
            .disposed(by: disposeBag)
        
        resultLayer.tableView.rx.modelSelected(ResultItem.self)
            .withUnretained(self)
            .subscribe{ owner, item in
                guard let url = item.owner?.url else { return }
                owner.delegate?.moveToLink(of: url)
            }.disposed(by: disposeBag)
        
        resultLayer.tableView.rx.prefetchRows
            .throttle(.seconds(3), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .asObservable()
            .withUnretained(self)
            .filter{ owner, value in
                guard !owner.viewModel.output.isError.value else {
                    return false
                }
                let isComplete = owner.viewModel.output.isComplete.value
                let isLoading = owner.viewModel.output.isLoading.value
                
                return !isComplete && !isLoading
            }
            .subscribe{ (owner, item) in
                owner.delegate?.nextPageScroll()
            }.disposed(by: disposeBag)
    }
    
    deinit {
        print("\(#fileID) DEINIT")
    }
    
}

extension ResultViewController: UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !viewModel.output.isError.value else { return }

        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            let isComplete = viewModel.output.isComplete.value
            let isLoading = viewModel.output.isLoading.value
            // 최하단 (true)  && 다음 페이지 O (false) && 로딩 X (false)
            guard !isComplete && !isLoading else { return }
            setFooterView()
        }
    }
        
    func setFooterView() {
        let footerView = resultLayer.tableView.dequeueReusableHeaderFooterView(withIdentifier: IndicatorFooterView.identifier) as? IndicatorFooterView
        resultLayer.tableView.tableFooterView = footerView
        footerView?.indicatorView.startAnimating()
        delegate?.nextPageScroll()
    }
}
