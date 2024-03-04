//
//  ResultViewLayer.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

class ResultLayerView: UIView {
    
    let recentTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle  = .none
        $0.rowHeight = 40
        $0.register(SearchUpdateCell.self, forCellReuseIdentifier: SearchUpdateCell.identifier)
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle  = .none
        $0.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
//        $0.register(IndicatorFooterView.self, forHeaderFooterViewReuseIdentifier: IndicatorFooterView.identifier)
    }
    
    let rateLimiView = RateLimitView().then{
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        setUI()
        setConstraint()
    }
    
    func setUI() {
        [tableView, recentTableView, rateLimiView].forEach(addSubview(_:))
    }
    
    func setConstraint() {
        recentTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        rateLimiView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
