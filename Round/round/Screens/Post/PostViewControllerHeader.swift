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
    var isSubscribed: Bool = false
    
    let backButton : Button = ButtonBuilder()
        .setFrame(CGRect(x: 20, y: 20, width: 40, height: 40))
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(Icons.back)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
    let actionButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .setPressBlockingTimer(0.5)
        .build()
    
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    var titleLabel : Text = Text(.title, .white)
    var descriptionLabel : Text = Text(.regular, .white)
    
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
            avatar.setImage(Images.avatarPlaceholder.uiimage())
        }
        name.text = viewModel.author?.userName
    }

    func setupDesign(_ viewModel : CardViewModel){
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        addSubview(backgroundImageView)
        addSubview(blurredEffectView)
        
        [titleLabel,descriptionLabel].forEach {
            blurredEffectView.contentView.addSubview($0)
        }
        
        [backButton,actionButton].forEach {
            addSubview($0)
        }
        actionButton.easy.layout(Trailing(20),Top(20),Width(40),Height(40))

        /// if BookmarksRealmManager().get(postId: viewModel.id) != nil {

        self.isSubscribed = viewModel.isSubscribed
        
        if viewModel.author?.uid == AccountManager.shared.data.uid {
              actionButton.setIcon(.settings)
          } else {
            actionButton.setIcon(viewModel.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        }
        
        blurredEffectView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        blurredEffectView.layer.cornerRadius = 40
        blurredEffectView.layer.masksToBounds = true
        backgroundImageView.easy.layout(
            Top(),Leading(),Trailing(),Bottom()
        )

        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        let attributedString = NSMutableAttributedString(string:  viewModel.description, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        descriptionLabel.attributedText = attributedString
        descriptionLabel.numberOfLines = 2
        descriptionLabel.easy.layout(
            Leading(25),Trailing(25),Bottom(20),Top(3).to(titleLabel)
        )
        descriptionLabel.sizeToFit()

        titleLabel.numberOfLines = 2
        titleLabel.easy.layout(
            Leading(25),Trailing(25),Top(20)
        )
        titleLabel.sizeToFit()

        setupAuthorAvatar(viewModel)
        

        layoutSubviews()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         let bigCheck = backButton.frame.insetBy(dx: -20, dy: -20)
         if bigCheck.contains(point) {
             return backButton
         }
        
        let bigMark = actionButton.frame.insetBy(dx: -20, dy: -20)
        if bigMark.contains(point) {
            return actionButton
        }
        
         return super.hitTest(point, with: event)
     }
    
    public var onAvatarPress : ()->() = { }
    
    @objc func routeToProfile(){
        onAvatarPress()
    }
}
