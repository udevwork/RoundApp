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
        .setIcon(Icons.back)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
    let saveToBookmark : Button = ButtonBuilder()
    .setStyle(.icon)
    .setColor(.clear)
    .setIcon(.bookmarkfill)
    .setIconColor(.white)
    .setIconSize(CGSize(width: 20, height: 20))
    .build()

    var gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)

    var titleLabel : Text = Text(.title, .white)
    var descriptionLabel : Text = Text(.article, .white)

    /// Author
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil

    init(frame: CGRect, viewModel: CardViewModel, card: CardView) {
        super.init(frame: frame)
        backgroundImageView.image = card.backgroundImageView.image
        setupDesign(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAuthorAvatar(_ viewModel : CardViewModel){
        authorAvatar = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        authorNameLabel = Text(.article, .white)
        guard let avatar = authorAvatar, let name = authorNameLabel else {
            return
        }
        addSubview(avatar)
        addSubview(name)
        name.easy.layout(
            Leading(20).to(avatar),
            Trailing(20),
            CenterY().to(avatar),
            Height(40)
        )
        
        avatar.easy.layout(
            Leading(20).to(backButton),Top(20),Height(40),Width(40)
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(routeToProfile))
        avatar.addGestureRecognizer(tap)
        
        if let url = viewModel.author?.photoUrl, let imageUrl = URL(string: url) {
            avatar.setImage(imageUrl)
        } else {
            avatar.setImage(UIImage(named: "avatarPlaceholder")!)
        }
        name.text = viewModel.author?.userName
    }

    func setupDesign(_ viewModel : CardViewModel){
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        addSubview(backgroundImageView)
        layer.addSublayer(gradient)
        [titleLabel,descriptionLabel,backButton,saveToBookmark].forEach {
            addSubview($0)
        }
        backButton.easy.layout(Leading(20),Top(20),Width(40),Height(40))
        saveToBookmark.easy.layout(Trailing(20),Top(20),Width(40),Height(40))
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
        if viewModel.authorID != AccountManager.shared.data.uid {
            setupAuthorAvatar(viewModel)
        }

        layoutSubviews()
    }

    
    public var onAvatarPress : ()->() = { }
    
    @objc func routeToProfile(){
        onAvatarPress()
    }
}
