//
//  BaseControllerViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

protocol BaseViewModel {
    associatedtype routerType: RouterProtocol
    var router: routerType? { get }
}

protocol RouterProtocol {
    associatedtype viewControllerModel
    associatedtype viewController
    var controller: viewController? { get }
    static func assembly(model: viewControllerModel) -> viewController
}
