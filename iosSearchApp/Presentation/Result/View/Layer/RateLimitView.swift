//
//  RateLimiView .swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/04.
//

import Foundation
import UIKit

class RateLimitView: UIView {
    var stackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let message = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.numberOfLines = 0
    }
    
    let url = UITextView().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.dataDetectorTypes = .link
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
        addSubview(stackView)
        [message, url].forEach(stackView.addArrangedSubview(_:))
    }
    
    func setConstraint() {
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func setUI(_ model: ResultRateLimit) {
        message.text = model.message
        url.text = model.url
    }
}
