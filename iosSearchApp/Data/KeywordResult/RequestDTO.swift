//
//  RequestDTO.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//


struct RequestDTO: Codable {
    var q: String = ""
    var page: Int = 1
    
    init(q: String, page: Int = 1) {
        self.q = q
        self.page = page
    }
    
    init() { }
}
