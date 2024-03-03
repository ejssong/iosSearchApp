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
    
    lazy var collectionView : UICollectionView = {
        let layout                        = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing         = 10
        layout.minimumInteritemSpacing    = 8
        layout.sectionInset               = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize          = UICollectionViewFlowLayout.automaticSize
        layout.headerReferenceSize.height = 40
        layout.footerReferenceSize.height = 40
        
        let view                          = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled              = false
        view.backgroundColor              = .clear
        view.showsVerticalScrollIndicator = false
        view.automaticallyAdjustsScrollIndicatorInsets = false
        view.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
        view.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        view.register(CustomFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomFooterView.identifier)
        view.contentInset = .zero
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.separatorStyle  = .none
        view.rowHeight = 40
        view.register(SearchUpdateCell.self, forCellReuseIdentifier: SearchUpdateCell.identifier)
        return view
    }()
    
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
        [collectionView, tableView].forEach(addSubview(_:))
    }
    
    func setConstraint() {
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
