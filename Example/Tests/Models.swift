//
//  Models.swift
//  ObjectConvertible_Tests
//
//  Created by Yu Sugawara on 9/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import ObjectConvertible
import RealmSwift

protocol ObjectType {
    var bool: Bool { get }
    var int: Int { get }
    var float: Float { get }
    var double: Double { get }
    var string: String { get }
}

/// Plain Old Swift Object
struct Object: ObjectType, Codable, ObjectConvertible {
    var bool: Bool
    var int: Int
    var float: Float
    var double: Double
    var string: String
    
    init(JSON: [String : Any]) {
        self.init(JSONData: try! JSONSerialization.data(
            withJSONObject: JSON,
            options: []))
    }
    
    init(JSONData: Data) {
        self = try! JSONDecoder().decode(
            Object.self,
            from: JSONData)
    }
    
    /// Value Object
    var VO: ObjectType {
        return self
    }
    
    /// Convert to Data Access Object
    ///
    /// - Returns: Data Access Object
    /// - Throws: An error if any value throws an error during decoding or encoding
    func convertToDAO() throws -> RealmObject {
        return try convert()
    }
}

/// Data Access Object
@objcMembers
class RealmObject: RealmSwift.Object, ObjectType, Codable, ObjectConvertible {
    dynamic var bool = false
    dynamic var int = 0
    dynamic var float: Float = 0
    dynamic var double: Double = 0
    dynamic var string = ""
    
    /// Convert to Value Object
    ///
    /// - Returns: Value Object
    /// - Throws: An error if any value throws an error during decoding or encoding
    func convertToVO() throws -> ObjectType {
        return try convertToDTO()
    }
    
    /// Convert to Data Transfer Object
    ///
    /// - Returns: Data Transfer Object
    /// - Throws: An error if any value throws an error during decoding or encoding
    func convertToDTO() throws -> RealmObject {
        return try convert()
    }
    
    /// Convert to Plain Old Swift Object
    ///
    /// - Returns: Plain Old Swift Object
    /// - Throws: An error if any value throws an error during decoding or encoding
    func convertToPOSO() throws -> Object {
        return try convert()
    }
}

/*---*/

@objcMembers
class Person: RealmSwift.Object, Codable, ObjectConvertible {
    dynamic var name = ""
    dynamic var cat: Cat?
    
    /// Convert to Data Transfer Object
    ///
    /// - Returns: Data Transfer Object
    /// - Throws: An error if any value throws an error during decoding or encoding
    func convertToDTO() throws -> Person {
        return try convert()
    }
}

@objcMembers
class Cat: RealmSwift.Object, Codable {
    dynamic var name: String = ""
}
