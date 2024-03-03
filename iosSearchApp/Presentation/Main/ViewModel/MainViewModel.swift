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
    let moveToMemo: (_ url: String) -> Void
}

protocol MainViewModelInput{
    func didSearchUpdate(of keyword: String)  //최근 검색 필터링
    func didSearchCancel()                    //검색 캔슬
    func didTapRemoveKeyword(of index: Int)   //최근 검색어 삭제
    func didTapRemoveAll()                    //최근 검색어 전체 삭제
    func moveToResult(of keyword: String)     //키워드 검색
    func moveToWebView(_ url: String)         //웹뷰 이동
}

protocol MainViewModelOutput {
    var recentSearchList: BehaviorRelay<[SectionModel]> { get set }
    var filterList : BehaviorRelay<[SectionModel]> { get set }
    var resultList : BehaviorRelay<[ResultResponseDTO]> { get set }
    var toastMessage: PublishSubject<String> { get set}
    var isSearching : Driver<Bool> { get set }
    var isComplete : Driver<Bool> { get set }
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: MainViewModel {
    
    private let usecase: MainUseCase
    private let actions: MainViewModelActions
    
    var recentSearchList: BehaviorRelay<[SectionModel]> = .init(value: [])
    var filterList : BehaviorRelay<[SectionModel]> = .init(value: [])
    var resultList : BehaviorRelay<[ResultResponseDTO]> = .init(value: [])
    var toastMessage: PublishSubject<String> = .init()
    var isSearching : Driver<Bool>
    var isComplete: Driver<Bool>
    
    init(usecase: MainUseCase, actions: MainViewModelActions) {
        self.usecase = usecase
        self.actions = actions
        isSearching = filterList.map{ !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        isComplete = resultList.map{ !$0.isEmpty }.asDriver(onErrorJustReturn: false)
        setModel()
    }
    
    private func setModel() {
        recentSearchList.accept([SectionModel(items: UserDefaultsManager.recentList ?? [] )])
    }
    
    /*
     검색 필터링
     */
    func didSearchUpdate(of keyword: String) {
        let list = UserDefaultsManager.recentList
        let value = list.sorted(by: { $0.date > $1.date }).filter{ $0.value.lowercased().contains(keyword) }
        
        filterList.accept([SectionModel(items: value)])
    }
    
    /**
     검색 취소
     */
    func didSearchCancel() {
        filterList.accept([])
        resultList.accept([])
    }
    
    /**
     검색결과 화면
     - keyword: 입력한 검색어
     */
    func moveToResult(of keyword: String) {
        insertArray(with: keyword)
       
        usecase.reqKeywordResult(of: RequestDTO(q: keyword)) { [weak self] data in
            guard let self = self else { return }
            switch data {
            case .success(let model):
                self.resultList.accept([model])
            case .failure(let error):
                self.toastMessage.onNext(error.localizedDescription)
            }
        }
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
        UserDefaultsManager.recentList.removeAll()
        recentSearchList.accept([])
    }
    
    /**
     해당 저장소 웹뷰 이동
     */
    func moveToWebView(_ url: String) {
        actions.moveToMemo(url)
    }
    
    func insertArray(with keyword: String) {
        var value = UserDefaultsManager.recentList
        if value.count == 10 {
            value.removeLast()
        }
        value.insert(SectionListModel(value: keyword), at: 0)
        UserDefaultsManager.recentList = value
        setModel()
    }
}
