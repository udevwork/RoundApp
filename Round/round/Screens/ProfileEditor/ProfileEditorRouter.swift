//
//  ProfileEditorRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 26.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ProfileEditorRouter: RouterProtocol {
    
    typealias viewControllerModel = ProfileEditorViewModel
    typealias viewController = ProfileEditorViewController
    
    weak var controller: ProfileEditorViewController?
    
    static func assembly(model: ProfileEditorViewModel) -> ProfileEditorViewController {
        model.router = ProfileEditorRouter()
        let vc : ProfileEditorViewController = ProfileEditorViewController(viewModel: model)
        model.router?.controller = vc
        return vc
    }
}
