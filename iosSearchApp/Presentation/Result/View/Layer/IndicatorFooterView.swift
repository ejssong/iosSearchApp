//
//  IndicatorFooterView.swift
//  iosSearchApp
//
//  Created by ejsong on 3/4/24.
//

import Foundation
import UIKit

final class IndicatorFooterView: UITableViewHeaderFooterView {
    static let identifier = "IndicatorFooterView"
    
    let indicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .medium
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        addSubview(indicatorView)
    }
    
    func setConstraint() {
        indicatorView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
