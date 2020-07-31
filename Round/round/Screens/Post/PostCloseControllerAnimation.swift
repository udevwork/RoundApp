//
//  PostCloseControllerAnimation.swift
//  round
//
//  Created by Denis Kotelnikov on 26.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import EasyPeasy

class PostCloseControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var card : CardView? = nil
    let transitionDuration: TimeInterval = 0.6
    let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7, animations: nil)
    var header : PostViewControllerHeader? = nil
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil
    
    let backgroundImageView : UIImageView = {
        let i : UIImageView =  UIImageView(frame: UIScreen.main.bounds)
        i.layer.masksToBounds = true
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    lazy var blurredEffectView: UIVisualEffectView = {
        let b = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        b.layer.cornerRadius = header!.blurredEffectView.layer.cornerRadius
        b.layer.masksToBounds = true
        return b
    }()
    
    /// back btn
    let backButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(.back)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 17, height: 15))
        .setCornerRadius(13)
        .setShadow(.NavigationBar)
        .build()
    
    let actionButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-20, y: 20), size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
    let viewCountIcon: UIImageView = {
        let i: UIImageView = UIImageView(image: Icons.eye.image())
        i.contentMode = .scaleAspectFit
        i.tintColor = #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1)
        return i
    }()
    
    let titleLabel: Text = {
        let t: Text = Text( .title, .white)
        t.numberOfLines = 2
        return t
    }()
    
    let descriptionLabel: Text = {
        let t: Text = Text(.regular, .white)
        t.numberOfLines = 2
        return t
    }()
    
    let viewCountLabel: Text = {
        let t: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1))
        return t
    }()
    
    let creationDateLabel: Text = {
        let t: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1))
        return t
    }()
        
    init(header : PostViewControllerHeader, card : CardView) {
        super.init()
        self.header = header
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let header = header, let card = card, let model = card.viewModel else {
            return
        }
        
        guard  let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        containerView.transform = CGAffineTransform(scaleX: fromViewController.view.transform.a, y: fromViewController.view.transform.d)

        toViewController.view.isHidden = false
        fromViewController.view.isHidden = true
        /// main image
       
        backgroundImageView.image = header.backgroundImageView.image
       

        /// title text
        
        titleLabel.frame = header.titleLabel.frame
        titleLabel.text = header.titleLabel.text
        /// descriptionLabel text
        descriptionLabel.frame = header.descriptionLabel.frame
        
        descriptionLabel.attributedText = header.descriptionLabel.attributedText
        
        /// avatar
        if let originalauthorAvatar = header.authorAvatar {
            authorAvatar = UserAvatarView(frame: originalauthorAvatar.frame)
            if let url = model.author?.photoUrl, let imageUrl = URL(string: url) {
                authorAvatar!.setImage(imageUrl)
            } else {
                authorAvatar!.setImage(Images.avatarPlaceholder.uiimage())
            }
            
        }
        
        if let originalauthorNameLabel = header.authorNameLabel {
            authorNameLabel = Text(.article, .white, originalauthorNameLabel.frame)
            authorNameLabel!.text = originalauthorNameLabel.text
        }
        
        actionButton.setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        blurredEffectView.frame = header.blurredEffectView.frame
        
//        viewCountLabel.frame = card.viewCountLabel.frame
//        viewCountIcon.frame = card.viewCountIcon.frame
//        viewCountLabel.text = card.viewCountLabel.text
//
//        creationDateLabel.frame = card.creationDateLabel.frame
//        creationDateLabel.text = card.creationDateLabel.text
//
        
        /// add Subview
        containerView.addSubview(fromViewController.view)
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(titleLabel)
        blurredEffectView.contentView.addSubview(descriptionLabel)
        if authorAvatar != nil && authorNameLabel != nil {
            containerView.addSubview(authorAvatar!)
            containerView.addSubview(authorNameLabel!)
        }
        backgroundImageView.addSubview(backButton)
        
        actionButton.frame = header.actionButton.frame
        backgroundImageView.addSubview(actionButton)
        
        backgroundImageView.addSubview(viewCountIcon)
        backgroundImageView.addSubview(viewCountLabel)
        backgroundImageView.addSubview(creationDateLabel)
            
    
        titleLabel.easy.layout(
            Leading(25),Trailing(25),Top(20)
        )
        
        descriptionLabel.easy.layout(
            Leading(25),Trailing(25),Bottom(20),Top(3).to(titleLabel)
        )
        
        blurredEffectView.easy.layout(Leading(15), Trailing(15), Bottom(15))


        if authorAvatar != nil && authorNameLabel != nil {
            
            authorNameLabel!.easy.layout(
                Leading(20).to(authorAvatar!),
                Trailing(20),
                CenterY().to(authorAvatar!),
                Height(40)
            )
        }
        
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        backButton.icon.alpha = 1
        
        actionButton.easy.layout(Trailing(20), Top(20))
        
        actionButton.icon.alpha = 1
            
//        viewCountIcon.bounds.origin = card.viewCountIcon.bounds.origin
//
//        viewCountLabel.bounds.origin = card.viewCountLabel.bounds.origin
//        creationDateLabel.bounds = card.creationDateLabel.bounds
//
        viewCountIcon.alpha = 0
        viewCountLabel.alpha = 0
        creationDateLabel.alpha = 0
        
        backgroundImageView.layer.cornerRadius = fromViewController.view.layer.cornerRadius
        
        let tempOriginalData = PostAnimatorHelper.pop()
        
        animator.addAnimations { [weak self] in
            containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.backgroundImageView.frame = tempOriginalData.mainPicOriginalFrame
            self?.backgroundImageView.layer.shadowRadius = 30
            self?.authorAvatar?.frame = tempOriginalData.avatarOriginalFrame
            self?.backgroundImageView.layer.cornerRadius = card.backgroundImageView.layer.cornerRadius
            self?.backButton.icon.alpha = 0
            self?.actionButton.icon.alpha = 0
            
//            if card.viewCountLabel.superview != nil {
//                self?.viewCountIcon.alpha = 1
//                self?.viewCountLabel.alpha = 1
//            }
//            
//            if card.creationDateLabel.superview != nil {
//                self?.creationDateLabel.alpha = 1
//                
//            }
//            
//            if card.authorAvatar.superview == nil {
//                self?.authorAvatar?.alpha = 0
//            }
//            
//            if card.authorNameLabel.superview == nil {
//                self?.authorNameLabel?.alpha = 0
//            }
//            
            containerView.layoutIfNeeded()
        }
        
        
        animator.startAnimation()
        animator.addCompletion { finished in
            fromViewController.view.isHidden = true
            if finished == .end {
                tempOriginalData.selectedCard.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
    
    deinit {
        print("CLOSE DEINIT")
    }
}
