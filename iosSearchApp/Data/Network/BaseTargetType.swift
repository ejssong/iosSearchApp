//
//  BaseTargetType.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
}
