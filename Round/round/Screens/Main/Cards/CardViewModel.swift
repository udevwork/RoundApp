//
//  CardViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


class CardViewModel {
    let id : String
    let mainImageURL : String
    let title : String
    let description : String
    let viewsCount : Int
    var author : User?
    let authorID : String?
    
    init(id : String, mainImageURL : String?, title : String?, description : String?, viewsCount : Int?, authorID : String?) {
        self.id = id
        self.mainImageURL = mainImageURL ?? "ImagePlaceholder"
        self.title = title ?? ""
        self.description = description ?? ""
        self.viewsCount = viewsCount ?? 0
        self.authorID = authorID
    }
    init() {
        self.id = ""
        self.mainImageURL = "ImagePlaceholder"
        self.title = "nil"
        self.description = "nil"
        self.viewsCount = 0
        self.author = nil
        self.authorID = nil
    }
    
    func loadAuthor(complition: @escaping (User?)->()){
        /// load author data
        if let id = authorID {
            FirebaseAPI.shared.getUserWith(id: id) { [weak self] user in
                self?.author = user
                complition(self?.author)
            }
        }
    }
}
