//
//  WebViewModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol WebViewModelOutput {
    var link : BehaviorRelay<String> { get set }
}

protocol WebViewModel: WebViewModelOutput { }

final class DefaultWebViewModel: WebViewModel {

    var link: BehaviorRelay<String> = .init(value: "")

    init(url: String) {
        link.accept(url)
    }
}
