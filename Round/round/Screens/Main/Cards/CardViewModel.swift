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
    let dowloadsCount : Int
    var isTamplateCard: Bool = false
    
    init(id : String, mainImageURL : String?, title : String?, description : String?, dowloadsCount : Int?) {
        self.id = id
        self.mainImageURL = mainImageURL ?? ""
        self.title = title ?? ""
        self.description = description ?? ""
        self.dowloadsCount = dowloadsCount ?? 0
        
    }
    
    init(id : String, response: PostResponse) {
        self.id = id
        self.mainImageURL = response.mainPicURL ?? ""
        self.title = response.title ?? ""
        self.description = response.description ?? ""
        self.dowloadsCount = response.dowloadsCount ?? 0
    }
    
    init() {
        isTamplateCard = true
        id = ""
        mainImageURL = ""
        title = localized(.postsLoadingTitle)
        description = localized(.postsLoadingSubtitle)
        dowloadsCount = 0
    }
    
}

