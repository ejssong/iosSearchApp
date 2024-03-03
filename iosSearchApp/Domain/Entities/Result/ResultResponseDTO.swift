//
//  ResultResponseDTO.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation

struct ResultResponseDTO : Decodable {
    var totalCnt : Int
    var incomplete: Bool
    var items : [ResultItem]
    
    enum CodingKeys : String, CodingKey {
        case totalCnt = "total_count"
        case incomplete = "incomplete_results"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCnt      = (try? container.decode(Int.self, forKey: .totalCnt)) ?? 0
        incomplete    = (try? container.decode(Bool.self, forKey: .incomplete)) ?? true
        items         = (try? container.decode([ResultItem].self, forKey: .items )) ?? []
    }
}

struct ResultItem: Decodable {
    var id: Int
    var name: String
    var owner: ResultOwner?
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id            = (try? container.decode(Int.self, forKey: .id )) ?? 0
        name          = (try? container.decode(String.self, forKey: .name )) ?? ""
        owner         = (try? container.decode(ResultOwner.self, forKey: .owner )) ?? nil
    }
}

struct ResultOwner: Decodable {
    var avatar: String
    var login: String
    
    enum CodingKeys : String, CodingKey {
        case avatar = "avatar_url"
        case login
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar        = (try? container.decode(String.self, forKey: .avatar )) ?? ""
        login         = (try? container.decode(String.self, forKey: .login )) ?? ""
    }
}
