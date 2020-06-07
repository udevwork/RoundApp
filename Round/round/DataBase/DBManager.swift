//
//  DBManager.swift
//  round
//
//  Created by Denis Kotelnikov on 24.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    public static var shared: DBManager = DBManager()
    public var realm: Realm!
    private let schemaVersion: UInt64 = 1
    private var config: Realm.Configuration? = nil
    private init(){
        configurateRealm()
    }
    
    private func configurateRealm(){
        config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { newSchemaVersion, oldSchemaVersion in
                switch oldSchemaVersion {
                case 1 :
                    newSchemaVersion.enumerateObjects(ofType: "RealmUser") { (oldObj, newObj) in
                        newObj!["id"] = UUID().uuidString
                    }
                default:
                    debugPrint("DBManager: RealmSchemaVersion: old: \(oldSchemaVersion), current: \(newSchemaVersion)")
                }
        })
        if let config = config {
            do {
                realm = try Realm(configuration: config)
            } catch let error {
                debugPrint("DBManager: Realm: ", error)
            }
            realm = try! Realm(configuration: config)
        } else {
            debugPrint("DBManager: Realm: config error")
        }
    }
    
    func DeleteAll() {
        do {
            try realm.write({
                self.realm.deleteAll()
            })
        } catch let error {
            debugPrint("DBManager: Realm: Delete error", error)
        }
    }
}

class BookmarksRealmManager {
    public func save(postId : String){
        do {
            try DBManager.shared.realm.write({
                DBManager.shared.realm.create(BookmarkRealm.self, value: ["postId": postId], update: .modified)
            })
        } catch let error {
            debugPrint("BookmarksRealmManager: Save error", error)
        }
    }
    
    public func get(postId : String) -> BookmarkRealm? {
        debugPrint("BookmarksRealmManager: bookmark with id: \(postId) is present in DB")
        return DBManager.shared.realm.object(ofType: BookmarkRealm.self, forPrimaryKey: postId)
    }
    
    public func remove(postId : String){
        try! DBManager.shared.realm.write({
            guard let object = DBManager.shared.realm.object(ofType: BookmarkRealm.self, forPrimaryKey: postId) else {
                debugPrint("BookmarksRealmManager: no bookmark with id: ", postId)
                return
            }
            DBManager.shared.realm.delete(object)
            debugPrint("BookmarksRealmManager: remove bookmark with id: ", postId)
        })
    }
}
