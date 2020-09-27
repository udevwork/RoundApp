//
//  DownloadPostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class DownloadPostCellViewModel : BasePostCellViewModelProtocol {
    var order: Int?
    var type : PostCellType?
    let text : String?
    
    init(model : TitlePostResponse) {
        self.type = model.type
        self.text = model.text
        self.order = model.order
    }
}
