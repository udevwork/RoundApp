//
//  LoginPageRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class LoginPageRouter: RouterProtocol {
    typealias viewControllerModel = LoginPageViewModel    
    typealias viewController = LoginPageViewController

    var controller: LoginPageViewController?
    
    static func assembly(model: LoginPageViewModel) -> LoginPageViewController {
        model.router = LoginPageRouter()
        let vc : LoginPageViewController = LoginPageViewController(viewModel: model)
        return vc
    }
}
