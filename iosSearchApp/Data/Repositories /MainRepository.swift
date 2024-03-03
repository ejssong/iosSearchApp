//
//  MainRepository.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation

final class MainRepository: MainRepositoryProtocol {

    init() { }
    
    //MARK: 키워드 검색 API
    func reqKeywordResult(dto: RequestDTO) -> Result<ResultResponseDTO, ResponseError> {
        KeywordResultAPI.reqKeywordResult(dto: dto) { [weak self] value in
            
        }
    
        return .failure(.invalid)
    }
    
}
