//
//  ResultViewLayer.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit

class ResultLayerView: UIView {
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle  = .none
        $0.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
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
        addSubview(tableView)
    }
    
    func setConstraint() {
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
