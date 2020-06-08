//
//  CardViewProfile.swift
//  round
//
//  Created by Denis Kotelnikov on 08.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import EasyPeasy

class CardViewProfile: CardView {
    override func setupDesign() {
        backgroundImageViewMask.addSubview(backgroundImageView)
        [backgroundImageViewMask,actionButton,viewCountIcon,viewCountLabel,creationDateLabel].forEach {
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
    
        viewCountIcon.contentMode = .scaleAspectFit
        viewCountIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42)
        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Top(15))
        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY(1).to(viewCountIcon))
        
        creationDateLabel.easy.layout(Leading(3).to(viewCountLabel),Trailing(20),CenterY(1).to(viewCountIcon))
        
        actionButton.easy.layout(Edges())
        
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutSubviews()
    }
}
