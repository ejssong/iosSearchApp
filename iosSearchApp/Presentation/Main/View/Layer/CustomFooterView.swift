//
//  CustomFooterView.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import RxSwift
import RxGesture
import UIKit

protocol CustomFooterDelegate: AnyObject {
    func didTapRemove()
}

class CustomFooterView: UICollectionReusableView {
    static let identifier = "CustomFooterView"
    
    var contentView = UIView()
    
    var label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "Purple")
        $0.textAlignment = .right
    }
    
    weak var delegate: CustomFooterDelegate?
    var disposeBag = DisposeBag()
    
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
        bind()
    }
    
    func setUI() {
        addSubview(contentView)
        contentView.addSubview(label)
    }
    
    func setConstraint() {
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints{
            $0.top.right.bottom.equalToSuperview()
        }
    }
    
    func bind(title: String) {
        label.text = title
    }
    
    func bind() {
        label.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.delegate?.didTapRemove()
            }).disposed(by: disposeBag)
    }
}
