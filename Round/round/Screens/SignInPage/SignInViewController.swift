//
//  SignInViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Purchases

class SignInViewController: BaseViewController<SignInViewModel> {
    
    let nameLabel = Text(.title, .label)
    let delimiter: UIView = UIView()
    let dascriptionLabel = Text(.article, .systemGray2)
    
    let subscribeButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setColor(.systemGray3)
        .setText("subscribe")
        .setTextColor(.white)
        .setIcon(.cart)
        .setIconColor(.white)
        .setCornerRadius(13)
        .build()
    
    
    override init(viewModel: SignInViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Subscribe"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        nameLabel.numberOfLines = 0
        dascriptionLabel.numberOfLines = 0
        
        
        nameLabel.text = "IDesigner subscription"
        dascriptionLabel.text = "Subscribe to get unlimited access to all icons, packs and designs!\nNew packages will be added every week, and the old ones will be replenished with new icons!\n\nThis is weekly subscription!"
        
        view.addSubview(nameLabel)
        nameLabel.easy.layout(Top(110),Leading(40),Trailing(40))
        nameLabel.sizeToFit()
        
        view.addSubview(delimiter)
        delimiter.easy.layout(Top(5).to(nameLabel),Leading(40),Trailing(40),Height(1))
        delimiter.backgroundColor = .systemGray2
        
        view.addSubview(dascriptionLabel)
        dascriptionLabel.easy.layout(Top(20).to(nameLabel),Leading(40),Trailing(40))
        dascriptionLabel.sizeToFit()
        
        view.addSubview(subscribeButton)
        subscribeButton.easy.layout(Top(40).to(dascriptionLabel),Leading(40))
        
        subscribeButton.setTarget {
            Purchases.shared.offerings { (offerings, error) in
                if let error = error {
                    print("FUCK ERROR")
                    print(error.localizedDescription)
                    return
                }
                if let offerings = offerings {
                    print(offerings.current as Any)
                    offerings.all.forEach { data in
                        print("FUCK: ", data.key)
                    }
                }
            }
        }
        
    }
}


