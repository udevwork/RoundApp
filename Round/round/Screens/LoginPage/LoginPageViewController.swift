//
//  LoginPageViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import EasyPeasy

class LoginPageViewController: BaseViewController<LoginPageViewModel> {
    override init(viewModel: LoginPageViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Users"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
    }

    
}
