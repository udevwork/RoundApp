//
//  PostBluredTitleDescriptionView.swift
//  round
//
//  Created by Denis Kotelnikov on 31.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostBluredTitleDescriptionView: UIView {
    
    var titleLabel : Text = Text(.title,  .white)
    var descriptionLabel : Text = Text(.regular, .white)
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    init(_ bluredView: PostBluredTitleDescriptionView) {
        super.init(frame: bluredView.frame)
        set(bluredView.titleLabel.text ?? "", bluredView.descriptionLabel.text ?? "")
        setupViewFromOtherView()
    }
    
    private func setupView() {
        addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(titleLabel)
        blurredEffectView.contentView.addSubview(descriptionLabel)
        
        blurredEffectView.easy.layout(Edges())
        blurredEffectView.layer.cornerRadius = 15
        blurredEffectView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2
        
        titleLabel.easy.layout(
            Leading(20),Trailing(20),Top(17)
        )
        
        descriptionLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(17),Top(3).to(titleLabel)
        )
        
    }
    
    private func setupViewFromOtherView(){
        setupView()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func set(_ title: String, _ description: String) {
        titleLabel.text = title
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        let attributedString = NSMutableAttributedString(string:  description, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        
        descriptionLabel.attributedText = attributedString
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
