//
//  MainViewController.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel : MainViewModel!
    
    static func create(with viewModel: MainViewModel) -> MainViewController {
        let mainVC = MainViewController()
        mainVC.viewModel = viewModel
        return mainVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }


}

