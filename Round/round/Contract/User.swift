//
//  User.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class User : Codable {
    let uid : String?
    let photoUrl : String?
    let userName : String?
    let bookmarks : [String]? = nil
    
    init(uid: String?, photoUrl: String?, userName: String?) {
        self.uid = uid
        self.photoUrl = photoUrl
        self.userName = userName ?? "empty user name"
    }
    
    init() {
        self.uid = nil
        self.photoUrl = nil
        self.userName = nil
    }
}


extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
