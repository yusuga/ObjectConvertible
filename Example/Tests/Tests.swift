import UIKit
import XCTest
import ObjectConvertible
import RealmSwift

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = UUID().uuidString
    }
    
    func testStructToRealmObject() {
        let obj = Object(JSON: JSONCreator.json())
        let realmObj = try! obj.convertToDAO()
        XCTAssertTrue(obj.equalValues(to: realmObj))
    }
    
    func testUnmanagedRealmObjectToStruct() {
        let realmObj = RealmObject(value: JSONCreator.json())
        let obj = try! realmObj.convertToPOSO()
        XCTAssertTrue(realmObj.equalValues(to: obj))
    }
    
    func testManagedRealmObjectToStruct() {
        let realmObj = RealmObject(value: JSONCreator.json())
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmObj)
        }
        
        let obj = try! realmObj.convertToPOSO()
        XCTAssertTrue(realmObj.equalValues(to: obj))
    }
    
    func testManagedRealmObjectToUnmanagedRealmObject() {
        let realmObj = RealmObject(value: JSONCreator.json())
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmObj)
        }
        
        let dtoRealmObj = try! realmObj.convertToDTO()
        XCTAssertNil(dtoRealmObj.realm)
        XCTAssertTrue(realmObj.equalValues(to: dtoRealmObj))
    }
    
    func testNestedRealmObject() {
        let person = Person(value: [
            "name" : "Sugawara",
            "cat" : ["name" : "Rao"]])
        
        XCTAssertNil(person.realm)
        XCTAssertNil(person.cat!.realm)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(person)
        }
        
        XCTAssertNotNil(person.realm)
        XCTAssertNotNil(person.cat!.realm)
        
        let dtoPerson = try! person.convertToDTO()
        XCTAssertNil(dtoPerson.realm)
        XCTAssertNil(dtoPerson.cat!.realm) // OK😊
        XCTAssertEqual(person.name, dtoPerson.name)
        XCTAssertEqual(person.cat!.name, dtoPerson.cat!.name)
    }
    
    func testTransformFailed() {
        XCTAssertThrowsError(try Person().convert() as RealmObject) // Swift.DecodingError.keyNotFound
    }
    
}
