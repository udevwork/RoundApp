//
//  SignInRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class SubscriptionsRouter: RouterProtocol {
    typealias viewControllerModel = SubscriptionsViewModel
    typealias viewController = SubscriptionsViewController
    
    weak var controller: SubscriptionsViewController?
    
    static func assembly(model: SubscriptionsViewModel) -> SubscriptionsViewController {
        let router = SubscriptionsRouter()
        model.router = router
        let vc = SubscriptionsViewController(viewModel: model)
        router.controller = vc
        return vc
    }
    
    func showTerms() {
        controller?.present(PDFViewer(file: .SUBSCRIPTIONTERMS), animated: true, completion: nil)
    }
    
    func showPrivacy() {
        controller?.present(PDFViewer(file: .PRIVACYPOLICY), animated: true, completion: nil)
    }
    
}
