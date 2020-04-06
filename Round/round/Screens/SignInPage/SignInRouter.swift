//
//  SignInRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class SignInRouter: RouterProtocol {
    var controller: SignInViewController?
    
    static func assembly(model: SignInViewModel) -> SignInViewController {
        model.router = SignInRouter()
            let vc : SignInViewController = SignInViewController(viewModel: model)
            return vc
    }
    
    typealias viewControllerModel = SignInViewModel
    
    typealias viewController = SignInViewController
    
    
}
