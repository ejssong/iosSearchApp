//
//  KeywordResultAPI.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Moya

struct KeywordResultAPI: Network {
    typealias Target =  ResultTargetType
    
    //MARK:
    //@escaping (Result<ResultResponseDTO, Error>
    static func reqKeywordResult(dto: RequestDTO, completion: @escaping (Bool) -> Void) {
        makeProvider().request(.reqKeywordResult(dto)) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    do {
                        completion(true)
//                        let model = try JSONDecoder().decode(TimeTableResponseDTO.self, from: response.data)
//                        completion(.success(model))
                    } catch {
                        completion(false)
//                        completion(.failure(TimeTableErrorCode.decodeError))
                    }
                default:
                    completion(false)
//                    completion(.failure(TimeTableErrorCode(rawValue: response.statusCode) ?? .none))
                }
            case let .failure(error):
                completion(false)
//                completion(.failure(error))
            }
        }
    }
}
