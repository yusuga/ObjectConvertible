//
//  Utils.swift
//  ObjectConvertible_Tests
//
//  Created by Yu Sugawara on 9/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct JSONCreator {
    static func json() -> [String: Any] {
        return ["bool": true,
                "int": Int.max,
                "float": Float.greatestFiniteMagnitude,
                "double": Double.greatestFiniteMagnitude,
                "string": UUID().uuidString]
    }
}

extension ObjectType {
    func equalValues<T: ObjectType>(to other: T) -> Bool {
        return bool == other.bool
            && int == other.int
            && float == other.float
            && double == other.double
            && string == other.string
    }
}
