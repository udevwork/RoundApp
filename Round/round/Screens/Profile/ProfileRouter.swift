//
//  ProfileRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ProfileRouter: RouterProtocol {
    typealias viewControllerModel = ProfileViewModel
    typealias viewController = ProfileViewController
    var controller: ProfileViewController?

    static func assembly(model: ProfileViewModel) -> ProfileViewController {
        model.router = ProfileRouter()
        let vc : ProfileViewController = ProfileViewController(viewModel: model)
        return vc
    }
}
