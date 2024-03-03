//
//  KeywordResultAPI.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Moya

enum ResponseError: Error {
    case decodeError
    case networkError
    case invalid
}

struct KeywordResultAPI: Network {
    typealias Target =  ResultTargetType
    
    //MARK:
    static func reqKeywordResult(dto: RequestDTO, completion: @escaping (Result<ResultResponseDTO, ResponseError>) -> Void) {
        makeProvider().request(.reqKeywordResult(dto)) { result in
            switch result {
            case let .success(response):
                do {
                    let model = try JSONDecoder().decode(ResultResponseDTO.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
