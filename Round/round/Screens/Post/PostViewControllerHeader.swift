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
    
    let backButton : IconLableBluredView = IconLableBluredView(icon: .back, text: "Back")
    
    let actionButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .setPressBlockingTimer(0.5)
        .build()
    
    let bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView()
    
    /// Author
    var avatarHeader: UserAvatarNameDate = UserAvatarNameDate()
    
    init(frame: CGRect, viewModel: CardViewModel, card: CardView) {
        super.init(frame: frame)
        backgroundImageView.image = card.backgroundImageView.image
        setupDesign(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAuthorAvatar(_ viewModel : CardViewModel){
        addSubview(avatarHeader)
        avatarHeader.easy.layout(Leading(20).to(backButton), Trailing(20).to(actionButton),CenterY().to(backButton))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(routeToProfile))
        avatarHeader.addGestureRecognizer(tap)
        
        avatarHeader.setUser(viewModel.author?.userName ?? "")
        avatarHeader.setAvatar(URL(string: viewModel.author?.photoUrl ?? ""))
        
    }
    
    func setupDesign(_ viewModel : CardViewModel){
        bottomTextBlockView.set(viewModel.title, viewModel.description)
        addSubview(backgroundImageView)
        addSubview(bottomTextBlockView)
        
        [backButton,actionButton].forEach {
            addSubview($0)
        }
        backButton.easy.layout(Leading(20),Top(20+Design.safeArea.top))
        actionButton.easy.layout(Trailing(20),CenterY().to(backButton),Width(40),Height(40))
        
        /// if BookmarksRealmManager().get(postId: viewModel.id) != nil {
        
        self.isSubscribed = viewModel.isSubscribed
        
        if viewModel.author?.uid == AccountManager.shared.data.uid {
            actionButton.setIcon(.settings)
        } else {
            actionButton.setIcon(viewModel.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        }
        
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        
        backgroundImageView.easy.layout(
            Top(),Leading(),Trailing(),Bottom()
        )
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        
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
