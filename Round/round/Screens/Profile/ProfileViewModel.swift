//
//  ProfileViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ProfileViewModel : BaseViewModel{
    var router: ProfileRouter?
    typealias routerType = ProfileRouter
    let user: User
    init(user: User) {
        self.user = user
    }
}
