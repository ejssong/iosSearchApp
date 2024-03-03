//
//  ResultTargetType.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Moya

enum ResultTargetType {
    case reqKeywordResult(RequestDTO)
}

extension ResultTargetType: BaseTargetType{

    var baseURL: URL {
        return URL(string: NetworkURL.URL_DOMAIN)!
    }
    
    var path: String {
        return "/search/repositories"
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var method: Method {
        switch self {
        case .reqKeywordResult:
            return .get
        }
    }
    
    var task: Task{
        switch self{
        case .reqKeywordResult(let data):
            return .requestParameters(parameters: data.toDic!, encoding: URLEncoding.default)
        }
    }
}
