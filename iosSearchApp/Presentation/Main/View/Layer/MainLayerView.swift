//
//  MainLayerView.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import Then

class MainLayerView: UIView {

    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then{
            $0.minimumLineSpacing         = 10
            $0.minimumInteritemSpacing    = 8
            $0.sectionInset               = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.estimatedItemSize          = UICollectionViewFlowLayout.automaticSize
            $0.headerReferenceSize.height = 40
            $0.footerReferenceSize.height = 40
        }
    ).then {
        $0.isPagingEnabled              = false
        $0.backgroundColor              = .clear
        $0.showsVerticalScrollIndicator = false
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        $0.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
        $0.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        $0.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomFooterView.identifier)
        $0.contentInset = .zero
    }
    
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
    }
    
    func setUI() {
        [collectionView].forEach(addSubview(_:))
    }
    
    func setConstraint() {
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
