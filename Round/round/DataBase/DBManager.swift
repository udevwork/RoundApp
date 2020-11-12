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
    private let schemaVersion: UInt64 = 2
    private var config: Realm.Configuration? = nil
    
    private init() {
        configurateRealm()
    }
    
    private func configurateRealm(){
        config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { newSchemaVersion, oldSchemaVersion in
                switch oldSchemaVersion {
                case 1 :
                    newSchemaVersion.enumerateObjects(ofType: "userPurchase") { (oldObj, newObj) in
                        newObj!["id"] = UUID().uuidString
                    }
                case 2 :
                    newSchemaVersion.enumerateObjects(ofType: "userPurchase") { (oldObj, newObj) in
                        newObj!["productID"] = oldObj?["productID"]
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
            //realm = try! Realm(configuration: config)
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

class ProductManager {
    public func save(productID : String){
        do {
            try DBManager.shared.realm.write({
                DBManager.shared.realm.create(userPurchase.self, value: ["productID": productID], update: .modified)
            })
        } catch let error {
            debugPrint("BookmarksRealmManager: Save error", error)
        }
    }
    
    public func save(archiveLocalPath: String, imageLocalPath: String, archiveName: String, archiveDescription: String){
        do {
            try DBManager.shared.realm.write({
                DBManager.shared.realm.create(iconsZipObject.self,
                                              value: ["archiveLocalPath": archiveLocalPath,
                                                      "imageLocalPath" : imageLocalPath,
                                                      "archiveName" : archiveName,
                                                      "archiveDescription" : archiveDescription
                                              ],
                                              update: .all)
            })
        } catch let error {
            debugPrint("BookmarksRealmManager: Save error", error)
        }
        
    }
    
    public func getArchives(complition: @escaping ([iconsZipObject])->()){
        complition(Array(DBManager.shared.realm.objects(iconsZipObject.self)))
    }
    
    public func get(productID : String) -> userPurchase? {
        debugPrint("BookmarksRealmManager: bookmark with id: \(productID) is present in DB")
        return DBManager.shared.realm.object(ofType: userPurchase.self, forPrimaryKey: productID)
    }
    
    public func remove(productID : String){
        try! DBManager.shared.realm.write({
            guard let object = DBManager.shared.realm.object(ofType: userPurchase.self, forPrimaryKey: productID) else {
                debugPrint("BookmarksRealmManager: no bookmark with id: ", productID)
                return
            }
            DBManager.shared.realm.delete(object)
            debugPrint("BookmarksRealmManager: remove bookmark with id: ", productID)
        })
    }
}
