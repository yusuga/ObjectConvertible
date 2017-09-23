//
//  ObjectConvertible.swift
//  ObjectConvertible
//
//  Created by Yu Sugawara on 9/22/17.
//

import Foundation

public protocol ObjectConvertible: Encodable {}

public extension ObjectConvertible {
    func convert<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(
            T.self,
            from: try JSONEncoder().encode(self))
    }
}
