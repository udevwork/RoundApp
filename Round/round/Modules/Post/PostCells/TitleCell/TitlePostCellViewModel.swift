//
//  TitlePostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class TitlePostCellViewModel : BasePostCellViewModelProtocol {
    var order: Int?
    var type : PostCellType?
    let title : String?
    
    init(model : TitlePostResponse) {
        self.type = model.type
        self.title = model.title
        self.order = model.order
    }
}
