//
//  Network .swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/02.
//

import Moya

protocol Network {
    associatedtype Target: TargetType
    static func makeProvider() -> MoyaProvider<Target>
}

extension Network {
    static func makeProvider() -> MoyaProvider<Target> {
        return MoyaProvider<Target>(plugins: [])
    }
}
