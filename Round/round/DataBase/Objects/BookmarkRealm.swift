//
//  userPurchase.swift
//  round
//
//  Created by Denis Kotelnikov on 31.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import RealmSwift

class userPurchase: Object {
    @objc dynamic var productID: String = ""
    
    override static func primaryKey() -> String? {
        return "productID"
    }
    
    convenience init(postId: String) {
        self.init()
        self.productID = productID
    }
}

class iconsZipObject: Object {
    @objc dynamic var archiveLocalPath: String = ""
    @objc dynamic var imageLocalPath: String = ""
    @objc dynamic var archiveName: String = ""
    @objc dynamic var archiveDescription: String = ""

    override static func primaryKey() -> String? {
        return "archiveLocalPath"
    }
    
    convenience init(archiveLocalPath: String, imageLocalPath: String, archiveName: String, archiveDescription: String) {
        self.init()
        self.archiveLocalPath = archiveLocalPath
        self.imageLocalPath = imageLocalPath
        self.archiveName = archiveName
        self.archiveDescription = archiveDescription
    }
}

extension userPurchase {
    static func ==(lhs: userPurchase, rhs: userPurchase) -> Bool {
        return (lhs.productID == rhs.productID)
    }
    
    static func !=(lhs: userPurchase, rhs: userPurchase) -> Bool {
        return (lhs.productID != rhs.productID)
    }
}

extension iconsZipObject {
    static func ==(lhs: iconsZipObject, rhs: iconsZipObject) -> Bool {
        return (lhs.archiveLocalPath == rhs.archiveLocalPath)
    }
    
    static func !=(lhs: iconsZipObject, rhs: iconsZipObject) -> Bool {
        return (lhs.archiveLocalPath != rhs.archiveLocalPath)
    }
}
