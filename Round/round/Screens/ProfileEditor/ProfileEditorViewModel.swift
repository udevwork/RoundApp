//
//  ProfileEditorViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 26.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class ProfileEditorViewModel: BaseViewModel {
    var router: ProfileEditorRouter?
    typealias routerType = ProfileEditorRouter
    let userName: String
    let userAvatar: UIImage
    init(userName: String, userAvatar: UIImage) {
        self.userName = userName
        self.userAvatar = userAvatar
    }
}
