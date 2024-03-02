//
//  MainViewModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModelActions{
    
}

protocol MainViewModelInput{
    func moveToResult(of keyword: String)
}

protocol MainViewModelOutput{
    var recentSearchList: BehaviorRelay<[SectionModel]> { get set }
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: MainViewModel {
    
    private let usecase: MainUseCase
    private let actions: MainViewModelActions
    var recentSearchList: BehaviorRelay<[SectionModel]> = .init(value: [])
    
    init(usecase: MainUseCase, actions: MainViewModelActions) {
        self.usecase = usecase
        self.actions = actions
        setModel()
    }
    
    private func setModel() {
        let value = ["삼겹살", "식빵", "불고기", "냉동과일", "밀키트", "방울토마토", "초콜릿", "쿠키", "소금빵", "샐러드"]
        
        recentSearchList.accept([SectionModel(items: value.map{ SectionListModel(value: $0)}) ] )
    }
    
    /**
     검색결과 화면
     - keyword: 입력한 검색어
     */
    func moveToResult(of keyword: String) {
       
    }
    
}
