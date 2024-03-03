//
//  ResultViewController.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {

    //결과 뷰
    var resultLayer = ResultLayerView().then{
        $0.backgroundColor = .systemPink
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    func commonInit() {
        setUI()
        setConstraint()
    }
    
    func setUI() {
        [resultLayer].forEach(view.addSubview(_:))
    }
    
    func setConstraint() {
        resultLayer.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
    
    
}
