//
//  TitlePostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class TitlePostCellViewModel : BasePostCellViewModelProtocol {
    var postType : PostCellType
    let text : String
    init(postType : PostCellType, text : String) {
        self.postType = postType
        self.text = text
    }
}
