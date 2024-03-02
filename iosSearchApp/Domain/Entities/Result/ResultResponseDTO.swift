//
//  ResultResponseDTO.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation

struct ResultResponseDTO : Decodable {
    var items: [LectureCodeResponseDTO]
    
    enum CodingKeys : String, CodingKey {
        case items = "Items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items         = (try? container.decode([LectureCodeResponseDTO].self, forKey: .items )) ?? []
    }
}

struct LectureCodeResponseDTO: Decodable {
    var code: String
    
    enum CodingKeys : String, CodingKey {
        case code = "lecture_code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code         = (try? container.decode(String.self, forKey: .code )) ?? ""
    }
}
