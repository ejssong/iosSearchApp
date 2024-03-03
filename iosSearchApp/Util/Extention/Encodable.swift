//
//  Encodable.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation

extension Encodable {
    var toDic: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictionary
    }
}
