//
//  BookmarkRealm.swift
//  round
//
//  Created by Denis Kotelnikov on 31.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkRealm: Object {
    @objc dynamic var postId: String = ""
    override static func primaryKey() -> String? {
        return "postId"
    }
    
    convenience init(postId: String) {
        self.init()
        self.postId = postId
    }
}

extension BookmarkRealm {
    static func ==(lhs: BookmarkRealm, rhs: BookmarkRealm) -> Bool {
        return (lhs.postId == rhs.postId)
    }
    
    static func !=(lhs: BookmarkRealm, rhs: BookmarkRealm) -> Bool {
        return (lhs.postId != rhs.postId)
    }
}
