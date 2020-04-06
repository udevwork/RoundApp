//
//  User.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class User {
    let ID : String
    let avatarImageURL : URL?
    let userName : String
    let isAnonymus: Bool
    
    init(ID : String? ,avatarImageURL : URL?, userName : String?, isAnonymus: Bool?) {
        self.ID = ID ?? "empty id"
        self.avatarImageURL = avatarImageURL // PLACEHOLDER IMAGE
        self.userName = userName ?? "empty user name"
        self.isAnonymus = isAnonymus ?? false
    }
    
}
