//
//  API.swift
//  round
//
//  Created by Denis Kotelnikov on 25.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

enum HTTPResult {
    case error
    case success
}

protocol API {
    func getPostCards(count: Int, complition : @escaping (HTTPResult, [CardViewModel]?) -> ())
}
