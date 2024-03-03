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
}

class ResultViewController: UIViewController {
    
    var resultLayer = ResultLayerView() //결과 뷰
    
    var dataSource: RxTableViewSectionedReloadDataSource<ResultResponseDTO>!
    
    weak var delegate : ResultViewDelegate?
    var dispoesBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    func commonInit() {
        setUI()
        setConstraint()
        setConfigTableDataSource()
        bind()
    }
    
    func setUI() {
        view.addSubview(resultLayer)
    }
    
    func setConstraint() {
        resultLayer.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func setConfigTableDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<ResultResponseDTO> { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else { return UITableViewCell() }
            cell.setModel(of: item)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            let totalCnt =  dataSource.sectionModels[index].totalCnt
            return "\(totalCnt)개 저장소"
        }
    }
    
    func bind() {
        resultLayer.tableView.rx.modelSelected(ResultItem.self)
            .withUnretained(self)
            .subscribe(onNext: { (owner, item ) in
                guard let url = item.owner?.url else { return }
                owner.delegate?.moveToLink(of: url)
            }).disposed(by: dispoesBag)
    }
    
}
