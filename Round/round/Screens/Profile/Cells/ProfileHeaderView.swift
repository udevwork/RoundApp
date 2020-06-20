//
//  ProfileHeaderView.swift
//  round
//
//  Created by Denis Kotelnikov on 25.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy


class ProfileViewControllerHeader : UIView {
    
    var animation: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut, animations: nil)
    
    let userAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    let userNameLabel : Text = Text(.window,  .label)
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    let menuStack : UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.axis = .horizontal
        s.distribution = .equalCentering
        s.spacing = 20
        return s
    }()
    
    let bookmarks : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIcon(.bookmarkfill)
        .setIconColor(.label)
        .setColor(.clear)
        .build()
    
    let editProfile : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIcon(.edit)
        .setIconColor(.label)
        .setColor(.clear)
        .build()
    
    let addPost : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIcon(Icons.add)
        .setIconColor(.label)
        .setColor(.clear)
        .build()
    
    let postCount: Text = Text(.regular, .tertiaryLabel, .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupView() {
        [blur,userAvatar,userNameLabel,postCount,menuStack].forEach {
          addSubview($0)
        }
        blur.easy.layout(Edges())
        userAvatar.easy.layout(Top(40),CenterX(),Width(150),Height(150))
        userNameLabel.easy.layout(Top(20).to(userAvatar,.bottom),CenterX())
        userNameLabel.sizeToFit()
        postCount.easy.layout(Top(5).to(userNameLabel,.bottom),CenterX())
        
        menuStack.easy.layout(CenterX(),Width(150),Height(21), Top(20).to(postCount,.bottom))
        
    }
    
    func setupStackMenu() {
        menuStack.addArrangedSubview(bookmarks)
        menuStack.addArrangedSubview(editProfile)
        menuStack.addArrangedSubview(addPost)
    }
    
    
    func expandAnimation() {
        animation.addAnimations { [weak self] in
            self?.menuStack.alpha = 1
            self?.menuStack.easy.layout(CenterX(),Width(150),Height(21), Top(20).to(self!.postCount,.bottom))
            self?.userAvatar.easy.layout(Top(40),CenterX(),Width(150),Height(150))
            self?.userNameLabel.easy.layout(Top(20).to(self!.userAvatar,.bottom),CenterX())
            self?.postCount.easy.layout(Top(2).to(self!.userNameLabel,.bottom),CenterX())
            self?.userAvatar.authorAvatarImageViewMask.layer.cornerRadius = 150/2
            self?.layoutSubviews()

        }
        animation.startAnimation()
    }
    
    func collapseAnimation() {
        animation.addAnimations { [weak self] in
            self?.menuStack.alpha = 0
            self?.menuStack.easy.layout(Height(0))
            self?.userAvatar.easy.layout(Top(10),Leading(20),Width(50),Height(50))
            self?.userAvatar.authorAvatarImageViewMask.layer.cornerRadius = 25
            self?.userNameLabel.easy.layout(Leading(20).to(self!.userAvatar),CenterY(-10))
            self?.postCount.easy.layout(Leading(20).to(self!.userAvatar),Top().to(self!.userNameLabel))
            self?.layoutSubviews()
        }
        animation.startAnimation()
    }
    
    
}
