//
//  GalleryPostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class GalleryPostCellViewModel : BasePostCellViewModelProtocol {
    var order: Int?
    var type : PostCellType?
    var imagesUrl : [String]?
    
    init(model : GalleryPostResponse) {
        self.type = model.type
        self.imagesUrl = model.imagesUrl
        self.order = model.order
    }
    
}
