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
    
    var animation: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: nil)
    
    let userAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let userNameLabel : Text = Text(.window,  .label)
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    let menuStack : UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .horizontal
        s.distribution = .equalCentering
        s.spacing = 15
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
        .setIcon(.settingsGear)
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
        
        userNameLabel.textAlignment = .left
        postCount.textAlignment = .left
        
        blur.easy.layout(Edges())
        userAvatar.easy.layout(Top(20),Leading(20),Width(100),Height(100))
        userNameLabel.easy.layout(Leading(18).to(userAvatar,.trailing),Trailing(20),Bottom(4).to(postCount,.top))
        postCount.easy.layout(Leading(20).to(userAvatar,.trailing),CenterY().to(userAvatar))
        menuStack.easy.layout(Leading(16).to(userAvatar,.trailing),Top(8).to(postCount,.bottom),Width(120),Height(21))
        
    }
    
    func setupStackMenu() {
        menuStack.addArrangedSubview(bookmarks)
        menuStack.addArrangedSubview(editProfile)
        menuStack.addArrangedSubview(addPost)
    }
    
    
    func expandAnimation() {
        animation.addAnimations { [weak self] in
            self?.menuStack.alpha = 1
            self?.postCount.alpha = 1
            self?.userAvatar.easy.layout(Top(20),Leading(20),Width(100),Height(100))
            self?.userNameLabel.easy.layout(Leading(18).to(self!.userAvatar,.trailing),Trailing(20),Bottom(4).to(self!.postCount,.top))
            self?.postCount.easy.layout(Leading(20).to(self!.userAvatar,.trailing),CenterY().to(self!.userAvatar))
            self?.menuStack.easy.layout(Leading(16).to(self!.userAvatar,.trailing),Top(8).to(self!.postCount,.bottom),Width(120),Height(21))
            self?.userAvatar.authorAvatarImageViewMask.layer.cornerRadius = 50
            self?.layoutSubviews()
            
        }
        animation.startAnimation()
    }
    
    func collapseAnimation() {
        animation.addAnimations { [weak self] in
            self?.menuStack.alpha = 0
            self?.postCount.alpha = 0
            self?.userAvatar.easy.layout(CenterY(),Leading(20),Width(40),Height(40))
            self?.userAvatar.authorAvatarImageViewMask.layer.cornerRadius = 20
            self?.userNameLabel.easy.layout(Leading(20).to(self!.userAvatar),CenterY())
            self?.postCount.easy.layout(Leading(20).to(self!.userAvatar),Top().to(self!.userNameLabel))
            self?.layoutSubviews()
        }
        animation.startAnimation()
    }
    
    
}
