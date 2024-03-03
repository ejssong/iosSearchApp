//
//  MainRepository.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation

final class DefaultMainRepository: MainRepositoryProtocol {
    init() { }
    
    //MARK: 키워드 검색 API
    func reqKeywordResult(dto: RequestDTO, completion: @escaping (Result<ResultResponseDTO, ResponseError>) -> Void) {
        KeywordResultAPI.reqKeywordResult(dto: dto) {
            switch $0 {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
