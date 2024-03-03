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
    func didSearchUpdate(of keyword: String)  //최근 검색 필터링
    func didSearchCancel()                    //검색 캔슬
    func moveToResult(of keyword: String)     //키워드 검색
    func didTapRemoveKeyword(of index: Int)   //최근 검색어 삭제
    func didTapRemoveAll()                    //최근 검색어 전체 삭제
}

protocol MainViewModelOutput {
    var recentSearchList: BehaviorRelay<[SectionModel]> { get set }
    var filterList : BehaviorRelay<[SectionModel]> { get set }
    var isSearching : Driver<Bool> { get set }
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: MainViewModel {
    
    private let usecase: MainUseCase
    private let actions: MainViewModelActions
    
    var recentSearchList: BehaviorRelay<[SectionModel]> = .init(value: [])
    var filterList : BehaviorRelay<[SectionModel]> = .init(value: [])
    var isSearching : Driver<Bool>
    
    init(usecase: MainUseCase, actions: MainViewModelActions) {
        self.usecase = usecase
        self.actions = actions
        isSearching = filterList.map{ !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        setModel()
    }
    
    private func setModel() {
        let value = ["삼겹살", "식빵", "식품", "불고기", "냉동과일", "밀키트", "방울토마토", "초콜릿", "쿠키", "소금빵", "샐러드"]
        UserDefaultsManager.recentList = value.map{ SectionListModel(value: $0) }
        
        recentSearchList.accept([SectionModel(items: value.map{ SectionListModel(value: $0)}) ] )
    }
    
    /**
     검색 필터링
     */
    func didSearchUpdate(of keyword: String) {
        guard let list = UserDefaultsManager.recentList else { return }
        let value = list.filter{ $0.value.lowercased().contains(keyword) }
        filterList.accept([SectionModel(items: value)])
    }
    
    func didSearchCancel() {
        filterList.accept([])
    }
    /**
     검색결과 화면
     - keyword: 입력한 검색어
     */
    func moveToResult(of keyword: String) {
       
    }
    
    /**
     선택한 키워드 삭제
     */
    func didTapRemoveKeyword(of index: Int) {
        guard var value = recentSearchList.value.first else { return }
        value.items.remove(at: index)
        recentSearchList.accept([value])
    }
    
    /**
     키워드 전체 삭제
     */
    func didTapRemoveAll() {
        recentSearchList.accept([])
    }
    
    
    
}
