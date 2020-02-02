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
    
    var viewModel : T
    
    var controllerIcon : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
  
    }

    
    init(viewModel : T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
