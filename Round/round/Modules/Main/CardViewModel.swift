//
//  CardViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


class CardViewModel {
    let mainImageURL : String
    let title : String
    let description : String
    let viewsCount : Int
    let author : User
    
    init(mainImageURL : String?, title : String?, description : String?, viewsCount : Int?, author : User?) {
        self.mainImageURL = mainImageURL ?? "" // PLACEHOLDER IMAGE
        self.title = title ?? ""
        self.description = description ?? ""
        self.viewsCount = viewsCount ?? 0
        self.author = author ?? User(ID: 0, avatarImageURL: nil, userName: nil)// empty user
    }

    
}
