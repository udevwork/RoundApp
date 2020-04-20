//
//  User.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class User : Decodable {
    let uid : String?
    let photoUrl : String?
    let userName : String?
    let posts : [String]?
    
    init(uid : String?, photoUrl : String?, userName : String?,posts : [String]?) {
        self.uid = uid
        self.photoUrl = photoUrl
        self.userName = userName ?? "empty user name"
        self.posts = posts ?? []
    }
    init() {
        self.uid = nil
        self.photoUrl = nil
        self.userName = nil
        self.posts = nil
    }
    
}
