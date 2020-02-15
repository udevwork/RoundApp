//
//  BaseViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController<T> : UIViewController{
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var navigation: RoundNavigationController {
        return self.navigationController as! RoundNavigationController
    }
    
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.additionalSafeAreaInsets = edgesForController()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    public func edgesForController() -> UIEdgeInsets {
        UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol NavigationDesignProtocol {
    var navTitle : String { get set }
    var navDescription : String { get set }
    var navIcon : UIImage { get set }
}
