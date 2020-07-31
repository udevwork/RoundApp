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
//        blurredEffectView.layer.cornerRadius = 13
//        blurredEffectView.layer.masksToBounds = true
//        backgroundImageViewMask.addSubview(backgroundImageView)
//        backgroundImageViewMask.addSubview(blurredEffectView)
//        [backgroundImageViewMask,actionButton,viewCountIcon,viewCountLabel,creationDateLabel].forEach {
//            addSubview($0)
//        }
//
//        addSubview(titleLabel)
//        addSubview(descriptionLabel)
        
        //  gradient.cornerRadius = 13
        backgroundImageViewMask.layer.cornerRadius = 13
        layer.cornerRadius = 13
        
        clipsToBounds = false
        backgroundImageViewMask.layer.masksToBounds = true
        
        backgroundImageViewMask.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageView.easy.layout(Edges())
        backgroundImageView.contentMode = .scaleAspectFill
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
//        let attributedString = NSMutableAttributedString(string:  descriptionLabel.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
//
//        descriptionLabel.attributedText = attributedString
//        descriptionLabel.numberOfLines = 2
//        descriptionLabel.easy.layout(
//            Leading(20),Trailing(20),Bottom(20)
//        )
//        descriptionLabel.sizeToFit()
//
//        titleLabel.numberOfLines = 2
//        titleLabel.easy.layout(
//            Leading(20),Trailing(20),Bottom(5).to(descriptionLabel)
//        )
//        titleLabel.sizeToFit()
//
//        blurredEffectView.easy.layout(Leading(10), Trailing(10), Bottom(10), Top(-8).to(titleLabel,.top))
//
//        viewCountIcon.contentMode = .scaleAspectFit
//        viewCountIcon.tintColor = #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1)
//        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Top(15))
//        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY().to(viewCountIcon))
//
//        creationDateLabel.easy.layout(Leading(3).to(viewCountLabel),Trailing(20),CenterY(1).to(viewCountIcon))
        
        actionButton.easy.layout(Edges())
        
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutSubviews()
    }
}
