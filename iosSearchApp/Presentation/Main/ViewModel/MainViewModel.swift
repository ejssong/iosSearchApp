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
    func didSearchUpdate(of keyword: String)    //최근 검색 필터링
    func didSearchCancel()                      //검색 캔슬
    func didTapRemoveKeyword(of text: String)   //최근 검색어 삭제
    func didTapRemoveAll()                      //최근 검색어 전체 삭제
    func moveToResult(of keyword: String)       //키워드 검색
    func nextPageScroll()                       //다음 페이지 로드
    func moveToWebView(_ url: String)           //웹뷰 이동
}

protocol MainViewModelOutput {
    var recentSearchList: BehaviorRelay<[SectionModel]> { get set } //최신 검색어 리스트
    var filterList : BehaviorRelay<[SectionModel]> { get set }      //키워드 필터링 리스트
    var resultList : BehaviorRelay<[ResultResponseDTO]> { get set } //키워드 검색 결과 리스트
    var toastMessage: PublishSubject<String> { get set }            //토스트 메시지
    var rateLimit: BehaviorRelay<ResultRateLimit?> { get set }      //API 로드 횟수 초과
    var searchType: BehaviorRelay<SearchType> { get set }           //입력 타입
    var isLoading: BehaviorRelay<Bool> { get set }                  //API 로딩 중 여부
    var isComplete : BehaviorRelay<Bool> { get set }                //API 로딩 완료 여부
    var isError : BehaviorRelay<Bool> { get set }                   //API 에러 여부 (횟수 초과)
}

protocol MainViewModel: MainViewModelInput, MainViewModelOutput { }

final class DefaultMainViewModel: MainViewModel {
    
    private let usecase: MainUseCase
    private let actions: MainViewModelActions
    
    //MARK: - OUTPUT
    var recentSearchList: BehaviorRelay<[SectionModel]>  = .init(value: [])
    var filterList : BehaviorRelay<[SectionModel]>       = .init(value: [])
    var resultList : BehaviorRelay<[ResultResponseDTO]>  = .init(value: [])
    var searchType: BehaviorRelay<SearchType>            = .init(value: .isEmtpy)
    var rateLimit: BehaviorRelay<ResultRateLimit?>       = .init(value: nil)
    var isLoading: BehaviorRelay<Bool>                   = .init(value: false)
    var toastMessage: PublishSubject<String>             = .init()
    var isComplete: BehaviorRelay<Bool>                  = .init(value: false)
    var isError: BehaviorRelay<Bool>                     = .init(value: false)
    var requestDTO: RequestDTO                           = RequestDTO()

    //MARK: - Init
    init(usecase: MainUseCase, actions: MainViewModelActions) {
        self.usecase = usecase
        self.actions = actions
        setModel()
    }
    
    private func setModel() {
        guard let list = UserDefaultsManager.recentList else {
            UserDefaultsManager.recentList = []
            recentSearchList.accept([])
            return
        }
        recentSearchList.accept(list.isEmpty ? [] : [SectionModel(items: list)])
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
                self.appendList(model)
            case .failure(let error):
                self.toastMessage.onNext(error.localizedDescription)
            }
        }
    }
    /**
     리스트 합치기
     */
    func appendList(_ model: ResultResponseDTO) {
        guard model.error.message.isEmpty else {
            rateLimit(model.error)
            return
        }
        
        guard var value = resultList.value.first else {
            resultList.accept([model])
            return
        }
        value.items += model.items
        resultList.accept([value])
        isComplete.accept(model.incomplete || (model.totalCnt == value.items.count))
    }
    
    /**
     최근 검색어  추가
     1. 해당 검색어가 이미 존재 한다면 지우고 새로 추가
     2. 10개 넘어가면 마지막 삭제 후 추가
     */
    func insertArray(with keyword: String) {
        guard var value = UserDefaultsManager.recentList else { return }
        
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
     리스트 조회 에러 (API 조회 횟수 초과)
     */
    func rateLimit(_ model: ResultRateLimit?) {
        isError.accept(true)
        if resultList.value.isEmpty {
            rateLimit.accept(model)
        }
    }
}

//MARK: - Intput Event Method
extension DefaultMainViewModel {
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
        guard let list = UserDefaultsManager.recentList else { return }
        let value = list.sorted(by: { $0.date > $1.date }).filter{ $0.value.lowercased().contains(keyword) }
        
        filterList.accept([SectionModel(items: value)])
    }
    
    /**
     검색 취소
     */
    func didSearchCancel() {
        filterList.accept(.init())
        resultList.accept(.init())
        isError.accept(.init())
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
     키워드 전체 삭제
     */
    func didTapRemoveAll() {
        UserDefaultsManager.recentList = []
        recentSearchList.accept(.init())
    }
    
    /**
     검색결과 화면
     - keyword: 입력한 검색어
     */
    func moveToResult(of keyword: String) {
        isLoading.accept(true)
        isComplete.accept(.init())
        searchType.accept(.isComplete)
        insertArray(with: keyword)
        fetchItem(of: RequestDTO(q: keyword, page: 1))
    }
    
    /**
     다음 페이지 조회
     */
    func nextPageScroll() {
        guard !isComplete.value || !isLoading.value else { return }
        var dto = requestDTO
        dto.page += 1
        fetchItem(of: dto)
    }
    
    /**
     해당 레퍼지토리  웹뷰 이동
     */
    func moveToWebView(_ url: String) {
        actions.moveToMemo(url)
    }
}
