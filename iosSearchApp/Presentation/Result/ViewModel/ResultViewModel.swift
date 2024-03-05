//
//  ResultViewModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation
import RxSwift
import RxCocoa

final class ResultViewModel {

    struct Output {
        var searchType: PublishSubject<SearchType> = .init()
        var rateLimit : PublishSubject<ResultRateLimit?> = .init()
        var filterList : PublishSubject<[SectionModel]> = .init()
        var resultList : BehaviorRelay<[ResultResponseDTO]> = .init(value: [])
        var isLoading : BehaviorRelay<Bool> = .init(value: false)
        var isComplete : BehaviorRelay<Bool> = .init(value: false)
        var isError: BehaviorRelay<Bool> = .init(value: false)
    }
    
    var output : Output        = Output()
    
    init() {
        
    }
}
