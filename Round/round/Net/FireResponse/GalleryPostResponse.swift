//
//  GalleryPostResponse.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

struct GalleryPostResponse : Codable {
    var type : PostCellType?
    var order : Int?
    let imagesUrl : [String]?
}
