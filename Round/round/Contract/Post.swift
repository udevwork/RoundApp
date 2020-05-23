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

extension Timestamp: TimestampType {}

struct Post : Codable {
    var description: String?
    var authorID: String?
    var title: String?
    var mainPicURL: String?
    var viewsCount: Int?
    var showsCount: Int?
    var creationDate: Timestamp?
    var location: Location?
}
