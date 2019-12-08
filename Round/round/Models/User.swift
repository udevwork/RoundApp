//
//  User.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class User {
    let ID : Int
    let avatarImageURL : String
    let userName : String
    
    init(ID : Int? ,avatarImageURL : String?, userName : String?) {
        self.ID = ID ?? 0
        self.avatarImageURL = avatarImageURL ?? "avatarPlaceholder" // PLACEHOLDER IMAGE
        self.userName = userName ?? ""
    }
}
