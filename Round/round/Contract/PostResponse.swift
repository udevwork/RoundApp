//
//  Post.swift
//  round
//
//  Created by Denis Kotelnikov on 04.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct PostResponse : Codable {
    var description: String?
    var title: String?
    var mainPicURL: String?
    var dowloadsCount: Int?
}
