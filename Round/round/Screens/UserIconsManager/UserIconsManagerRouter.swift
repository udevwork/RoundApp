//
//  UserIconsManagerRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 12.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class UserIconsManagerRouter: RouterProtocol {
    weak var controller: UserIconsManagerViewController?
    
    typealias viewControllerModel = UserIconsManagerViewModel
    
    typealias viewController = UserIconsManagerViewController
    
    
    
    static func assembly(model: UserIconsManagerViewModel) -> UserIconsManagerViewController {
        let router = UserIconsManagerRouter()
        model.router = router
        let vc = UserIconsManagerViewController(viewModel: model)
        router.controller = vc
        return vc
    }
    

}
