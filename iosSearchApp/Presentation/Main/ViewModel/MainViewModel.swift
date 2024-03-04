//
//  MainViewModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchType {
    case isEmtpy
    case isSearching
    case isComplete
}

struct MainViewModelActions{
    let moveToMemo: (_ url: String) -> Void
}

protocol MainViewModelInput{
    func didSearchUpdate(of keyword: String)  //최근 검색 필터링
    func didSearchCancel()                    //검색 캔슬
    func didTapRemoveKeyword(of text: String) //최근 검색어 삭제
    func didTapRemoveAll()                    //최근 검색어 전체 삭제
    func moveToWebView(_ url: String)         //웹뷰 이동
    func moveToResult(of keyword: String)  //키워드 검색
    func nextPageScroll()                   //다음 페이지 로드
}

protocol MainViewModelOutput {
    var recentSearchList: BehaviorRelay<[SectionModel]> { get set }
    var filterList : BehaviorRelay<[SectionModel]> { get set }
    var resultList : BehaviorRelay<[ResultResponseDTO]> { get set }
    var toastMessage: PublishSubject<String> { get set }
    var rateLimit: BehaviorRelay<ResultRateLimit?> { get set }
    var searchType: BehaviorRelay<SearchType> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var requestDTO : RequestDTO { get set }
    var isInComplete : BehaviorRelay<Bool> { get set }
   
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: MainViewModel {
    
    private let usecase: MainUseCase
    private let actions: MainViewModelActions
    
    var recentSearchList: BehaviorRelay<[SectionModel]> = .init(value: [])
    var filterList : BehaviorRelay<[SectionModel]> = .init(value: [])
    var resultList : BehaviorRelay<[ResultResponseDTO]> = .init(value: [])
    var searchType: BehaviorRelay<SearchType> = .init(value: .isEmtpy)
    var rateLimit: BehaviorRelay<ResultRateLimit?> = .init(value: nil)
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    var toastMessage: PublishSubject<String> = .init()
    var requestDTO: RequestDTO = RequestDTO()
    var isInComplete: BehaviorRelay<Bool> = .init(value: false)

    init(usecase: MainUseCase, actions: MainViewModelActions) {
        self.usecase = usecase
        self.actions = actions
        setModel()
    }
    
    private func setModel() {
        let list = UserDefaultsManager.recentList
        recentSearchList.accept(list.isEmpty ? [] : [SectionModel(items: list)])
    }
    
    /*
     검색 필터링
     */
    func didSearchUpdate(of keyword: String) {
        if keyword.isEmpty{
            didSearchCancel()
            searchType.accept(.isEmtpy)
            return
        }
        
        searchType.accept(.isSearching)
        let list = UserDefaultsManager.recentList
        let value = list.sorted(by: { $0.date > $1.date }).filter{ $0.value.lowercased().contains(keyword) }
        
        filterList.accept([SectionModel(items: value)])
    }
    
    /**
     검색 취소
     */
    func didSearchCancel() {
        filterList.accept(.init())
        resultList.accept(.init())
    }
    
    /**
     검색결과 화면
     - keyword: 입력한 검색어
     - isInitial : 최근 검색어 저장 여부
     */
    func moveToResult(of keyword: String) {
        isLoading.accept(true)
        searchType.accept(.isComplete)
        insertArray(with: keyword)
        fetchItem(of: RequestDTO(q: keyword, page: 1))
    }
    
    /**
     다음 페이지 조회
     */
    func nextPageScroll() {
        guard !isInComplete.value || isLoading.value else { return }
        var dto = requestDTO
        dto.page += 1
        fetchItem(of: dto)
    }
    
    /**
    리스트 조회
     */
    func fetchItem(of dto: RequestDTO) {
        requestDTO = dto
        usecase.reqKeywordResult(of: dto) { [weak self] data in
            guard let self = self else { return }
            self.isLoading.accept(false)
            switch data {
            case .success(let model):
                self.isInComplete.accept(model.incomplete)
                model.error.message.isEmpty ? self.appendList(model) : self.rateLimit(model.error)
            case .failure(let error):
                self.toastMessage.onNext(error.localizedDescription)
            }
        }
    }
    /**
     리스트 합치기
     */
    func appendList(_ model: ResultResponseDTO) {
        guard var value = resultList.value.first else {
            resultList.accept([model])
            return
        }
        value.items += model.items
        resultList.accept([value])
    }
    
    /**
     선택한 키워드 삭제
     */
    func didTapRemoveKeyword(of text: String) {
        guard var list = recentSearchList.value.first?.items as? [SectionListModel],
              let model = list.filter({ $0.value == text }).first,
              let index = list.firstIndex(of: model) else { return }
        
        list.remove(at: index)
        UserDefaultsManager.recentList = list
        recentSearchList.accept(list.isEmpty ? [] : [SectionModel(items: list)])
    }
    
    /**
     최근 검색어  추가
     1. 해당 검색어가 이미 존재 한다면 지우고 새로 추가
     2. 10개 넘어가면 마지막 삭제 후 추가
     */
    func insertArray(with keyword: String) {
        var value = UserDefaultsManager.recentList
        
        if let model = value.filter({ $0.value == keyword }).first,
           let index = value.firstIndex(of: model) {
            value.remove(at: index)
        }
        
        if value.count == 10 {
            value.removeLast()
        }
        value.insert(SectionListModel(value: keyword), at: 0)
        UserDefaultsManager.recentList = value
        setModel()
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
    
    /**
     리스트 조회 에러 (API 조회 횟수 초과)
     */
    func rateLimit(_ model: ResultRateLimit?) {
        if resultList.value.isEmpty {
            rateLimit.accept(model)
        }
    }
}
