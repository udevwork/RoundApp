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
    var downloadLink : String?
    var fileSize: String?
    
    init(model : DownloadPostResponse) {
        self.type = model.type
        self.order = model.order
        self.downloadLink = model.downloadLink
        self.fileSize = model.fileSize

    }
}
