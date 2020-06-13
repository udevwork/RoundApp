//
//  CardViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Firebase

class CardViewModel {
    let id : String /// in firebase it is doc id
    let mainImageURL : String
    let title : String
    let description : String
    let viewsCount : Int
    var author : User?
    let creationDate: Timestamp?
    var isSubscribed: Bool {
        var res: Bool = false
        AccountManager.shared.data.bookmarks.forEach { id in
            if self.id == id {
                res = true
                print(id, self.id , res)

            }
        }
        return res
    }
    
    var isSelfPost: Bool {
        return self.author?.uid == AccountManager.shared.data.uid
    }
    
    init(id : String, mainImageURL : String?, title : String?, description : String?, viewsCount : Int?, author : User?, creationDate: Timestamp?) {
        self.id = id
        self.mainImageURL = mainImageURL ?? ""
        self.title = title ?? ""
        self.description = description ?? ""
        self.viewsCount = viewsCount ?? 0
        self.author = author
        self.creationDate = creationDate
    }
    
    init(id : String, response: PostResponse) {
        self.id = id
        self.mainImageURL = response.mainPicURL ?? ""
        self.title = response.title ?? ""
        self.description = response.description ?? ""
        self.viewsCount = response.viewsCount ?? 0
        self.author = response.author
        self.creationDate = response.creationDate
    
    }
    
    init() {
        self.id = ""
        self.mainImageURL = ""
        self.title = "nil"
        self.description = "nil"
        self.viewsCount = 0
        self.author = nil
        self.author = nil
        self.creationDate = nil
    }
}
