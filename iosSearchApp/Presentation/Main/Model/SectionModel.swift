//
//  SectionModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import RxDataSources

struct SectionModel {
    var header: String = "최근 검색"
    var footer: String = "전체 삭제"
    var items: [Item]
}

extension SectionModel : AnimatableSectionModelType {
    typealias Item = SectionViewModel
    
    init(original: SectionModel, items: [SectionViewModel]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

class SectionViewModel : Equatable, IdentifiableType {
    static func == (lhs: SectionViewModel, rhs: SectionViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    let id = UUID().uuidString
    
    var identity: String {
       return id
    }
}


class SectionListModel: SectionViewModel, Codable, Hashable {
    var value: String
    var date: Date = Date()
    
    init(value: String) {
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    static func == (lhs: SectionListModel, rhs: SectionListModel) -> Bool {
        return lhs.value == rhs.value
    }
}
