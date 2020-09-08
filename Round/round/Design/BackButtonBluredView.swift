//
//  BackButtonBluredView.swift
//  round
//
//  Created by Denis Kotelnikov on 31.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class iconLableBluredView: UIView {
    var arrowIcon : Text = Text(.title,  .white)
    var descriptionLabel : Text = Text(.regular, .white)
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(titleLabel)
        blurredEffectView.contentView.addSubview(descriptionLabel)
        
        blurredEffectView.easy.layout(Edges())
        blurredEffectView.layer.cornerRadius = 40
        blurredEffectView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2
        
        titleLabel.easy.layout(
            Leading(25),Trailing(25),Top(20)
        )
        
        descriptionLabel.easy.layout(
            Leading(25),Trailing(25),Bottom(20),Top(3).to(titleLabel)
        )
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
