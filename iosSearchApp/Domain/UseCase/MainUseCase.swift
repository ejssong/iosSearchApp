//
//  MainUseCase.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation

protocol MainUseCase{
    func reqKeywordResult(of dto: RequestDTO, completion: @escaping (Result<ResultResponseDTO, ResponseError>) -> Void)
}

class DefaultMainUseCase : MainUseCase {
    
    private let repository: MainRepositoryProtocol
    
    init(repository: MainRepositoryProtocol) {
        self.repository = repository
    }
    
    func reqKeywordResult(of dto: RequestDTO, completion: @escaping (Result<ResultResponseDTO, ResponseError>) -> Void) {
        repository.reqKeywordResult(dto: dto) { completion($0) }
    }

}


