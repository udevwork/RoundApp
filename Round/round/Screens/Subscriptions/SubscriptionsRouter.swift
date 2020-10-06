//
//  SignInRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class SubscriptionsRouter: RouterProtocol {
    var controller: SubscriptionsViewController?
    
    static func assembly(model: SubscriptionsViewModel) -> SubscriptionsViewController {
        model.router = SubscriptionsRouter()
            let vc : SubscriptionsViewController = SubscriptionsViewController(viewModel: model)
            return vc
    }
    
    typealias viewControllerModel = SubscriptionsViewModel
    
    typealias viewController = SubscriptionsViewController
    
    
}
