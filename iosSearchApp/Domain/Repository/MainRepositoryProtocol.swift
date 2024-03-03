//
//  MainRepositoryProtocol.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/01.
//

import Foundation

protocol MainRepositoryProtocol {
    func reqKeywordResult(dto: RequestDTO) -> Result<ResultResponseDTO, ResponseError>
}
