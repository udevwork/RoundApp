//
//  CardViewSimple.swift
//  round
//
//  Created by Denis Kotelnikov on 08.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import EasyPeasy

class CardViewSimple: CardView {
    override func setupDesign() {
        backgroundImageViewMask.addSubview(backgroundImageView)
        [backgroundImageViewMask,actionButton].forEach {
            addSubview($0)
        }
        backgroundImageViewMask.layer.addSublayer(gradient)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        gradient.cornerRadius = 13
        backgroundImageViewMask.layer.cornerRadius = 13
        layer.cornerRadius = 13
        
        clipsToBounds = false
        backgroundImageViewMask.layer.masksToBounds = true

        backgroundImageViewMask.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageView.easy.layout(Edges())
        backgroundImageView.contentMode = .scaleAspectFill
        
        let attributedString = NSMutableAttributedString(string: descriptionLabel.text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.numberOfLines = 3
        descriptionLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        descriptionLabel.sizeToFit()
        
        titleLabel.numberOfLines = 1
        titleLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(descriptionLabel)
        )
        titleLabel.sizeToFit()
        
        actionButton.easy.layout(Edges())
        
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutSubviews()
    }
}
