//
//  WebViewController.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import UIKit
import WebKit
import SnapKit
import RxSwift

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{
    
    var webView = WKWebView()
    
    var viewModel: WebViewModel!
    
    var disposeBag = DisposeBag()
    
    static func create(with viewModel: WebViewModel) -> WebViewController {
        let webVC = WebViewController()
        webVC.viewModel = viewModel
        return webVC
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.link
            .withUnretained(self)
            .subscribe(onNext: { (owner, url) in
                guard let url = URL(string: url) else { return }
                owner.webView.load( URLRequest(url: url))
            }).disposed(by: disposeBag)
    }
    
    deinit {
        print("\(#fileID) DEINIT" )
    }
}
