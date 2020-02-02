//
//  ArticlePostResponse.swift
//  round
//
//  Created by Denis Kotelnikov on 31.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

struct ArticlePostResponse : Codable {
    var type : PostCellType?
    var order : Int?
    let text : String?
}
