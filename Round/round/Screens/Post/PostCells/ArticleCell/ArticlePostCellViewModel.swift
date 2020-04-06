//
//  ArticlePostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ArticlePostCellViewModel : BasePostCellViewModelProtocol{
    var order: Int?
    var type: PostCellType?
    let text : String?
    
    init(model : ArticlePostResponse) {
        self.type = model.type
        self.text = model.text
        self.order = model.order
    }
}
