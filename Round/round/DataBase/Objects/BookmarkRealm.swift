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

extension userPurchase {
    static func ==(lhs: userPurchase, rhs: userPurchase) -> Bool {
        return (lhs.productID == rhs.productID)
    }
    
    static func !=(lhs: userPurchase, rhs: userPurchase) -> Bool {
        return (lhs.productID != rhs.productID)
    }
}
