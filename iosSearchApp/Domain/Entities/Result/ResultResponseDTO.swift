//
//  ResultResponseDTO.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import RxDataSources

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

extension ResultResponseDTO : AnimatableSectionModelType {
    typealias Item = ResultItem
    
    init(original: ResultResponseDTO, items: [ResultItem]) {
        self = original
        self.items = items
    }
    
    var identity: Int {
        return totalCnt
    }
}

class ResultItem: SectionViewModel, Codable, Hashable {
    var name: String
    var owner: ResultOwner?
    
    enum CodingKeys : String, CodingKey {
        case name
        case owner
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name          = (try? container.decode(String.self, forKey: .name )) ?? ""
        owner         = (try? container.decode(ResultOwner.self, forKey: .owner )) ?? nil
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: ResultItem, rhs: ResultItem) -> Bool {
        return lhs.name == rhs.name
    }
}

class ResultOwner: SectionViewModel, Codable, Hashable {
    var avatar: String
    var login: String
    var url: String
    
    enum CodingKeys : String, CodingKey {
        case avatar = "avatar_url"
        case login
        case url = "html_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar        = (try? container.decode(String.self, forKey: .avatar )) ?? ""
        login         = (try? container.decode(String.self, forKey: .login )) ?? ""
        url           = (try? container.decode(String.self, forKey: .url )) ?? ""
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
    
    static func == (lhs: ResultOwner, rhs: ResultOwner) -> Bool {
        return lhs.login == rhs.login
    }
}
