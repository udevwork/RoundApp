//
//  SimplePhotoPostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


class SimplePhotoPostCellViewModel : BasePostCellViewModelProtocol{
    var postType : PostCellType

    let imageUrl : String
    init(postType : PostCellType, imageUrl : String) {
        self.postType = postType

        self.imageUrl = imageUrl
    }
}
