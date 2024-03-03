//
//  RecentSearchCell.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift

protocol RecentSearchDelegate: AnyObject {
    func delete(_ label: String)
}

class RecentSearchCell: UICollectionViewCell {
    static let identifier = "RecentSearchCell"
    
    var containerView = UIView().then {
        $0.backgroundColor = UIColor(named: "Background")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    var insetView = UIView()
    
    var stackView = UIStackView().then{
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    var label = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "Label")
    }
    
    var deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        $0.tintColor = UIColor(named: "Label")
    }
    
    var index: Int = 0
    weak var delegate : RecentSearchDelegate?
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit() {
        setUI()
        setConstraint()
        bind()
    }
    
    func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(insetView)
        insetView.addSubview(stackView)
        [label, deleteButton].forEach(stackView.addArrangedSubview(_:))
    }
    
    func setConstraint() {
        containerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        insetView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(8)
        }
        
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        deleteButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                guard let text = owner.label.text else { return }
                owner.delegate?.delete(text)
            }).disposed(by: disposeBag)
    }
}
