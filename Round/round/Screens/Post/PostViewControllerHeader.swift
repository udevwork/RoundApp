//
//  PostViewControllerHeader.swift
//  round
//
//  Created by Denis Kotelnikov on 26.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import EasyPeasy

class PostViewControllerHeader: UIView {

    var backgroundImageView : UIImageView = UIImageView()

    let backButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(Icons.back.image())
        .setIconColor(.white)
        .setIconSize(CGSize(width: 17, height: 15))
        .setCornerRadius(22)
        .setShadow(.NavigationBar)
        .build()

    var gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.cardGradient.cgColor, UIColor.clear.cgColor], type: .axial)

    var titleLabel : Text = Text(.title, .white)

    var descriptionLabel : Text = Text(.article, .white)

    var authorAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    var authorNameLabel : Text = Text(.article, .white)

    init(frame: CGRect, viewModel: CardViewModel, card: CardView) {
        super.init(frame: frame)
        backgroundImageView.image = card.backgroundImageView.image
        setupData(viewModel)
        setupDesign()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    fileprivate func setupDesign(){
        addSubview(backgroundImageView)
        layer.addSublayer(gradient)
        [titleLabel,descriptionLabel,authorAvatar,authorNameLabel,backButton].forEach {
            addSubview($0)
        }
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        gradient.frame = bounds
        backgroundImageView.easy.layout(
            Top(),Leading(),Trailing(),Bottom()
        )

        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true

        let attributedString = NSMutableAttributedString(string: descriptionLabel.text!)
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

        authorNameLabel.easy.layout(
            Leading(20).to(authorAvatar),
            Trailing(20),
            CenterY().to(authorAvatar),
            Height(40)
        )

        authorAvatar.easy.layout(
            Leading(20).to(backButton),Top(20),Height(40),Width(40)
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(routeToProfile))
        authorAvatar.addGestureRecognizer(tap)

    }

    func setupData(_ viewModel : CardViewModel){
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        if let url = viewModel.author?.photoUrl, let imageUrl = URL(string: url) {
            authorAvatar.setImage(imageUrl)
        }
        authorNameLabel.text = viewModel.author?.userName
        layoutSubviews()
    }
    
    public var onAvatarPress : ()->() = { }
    
    @objc func routeToProfile(){
        onAvatarPress()
    }
}
