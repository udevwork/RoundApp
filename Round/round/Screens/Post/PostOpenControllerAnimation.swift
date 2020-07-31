//
//  PushAnimator.swift
//  round
//
//  Created by Denis Kotelnikov on 26.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostOpenControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let transitionDuration: TimeInterval = 0.6
    var card : CardView? = nil
    
//    lazy var authorAvatar : UserAvatarView = UserAvatarView(frame: card?.authorAvatar.frame ?? .zero)
//
//    lazy var authorNameLabel : Text = Text(.article, .white, card?.authorNameLabel.frame ?? .zero)
//
    let titleLabel : Text = {
        let text : Text = Text(.title, .white)
        return text
    }()
    
    let descriptionLabel : Text = Text(.regular, .white)

    let backgroundImageView : UIImageView =  UIImageView()
    
    lazy var backButton: Button = {
        let button : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 40, height: 40)))
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(.back)
            .setIconColor(.white)
            .setIconSize(CGSize(width: 20, height: 20))
            .build()
        button.icon.alpha = 0
        return button
    }()
    
    lazy var actionButton : Button = ButtonBuilder()
        .setFrame(card!.actionButton.frame)
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))

    
    init(card : CardView) {
        super.init()
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let card = card else { return }
        guard let model = card.viewModel else { return }
        
        guard /*let fromViewController = transitionContext.viewController(forKey: .from),*/
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        /// let to = toViewController as! PostViewController
        
        toViewController.view.frame = UIScreen.main.bounds
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.isOpaque = false
        toViewController.view.layer.cornerRadius = 0
        toViewController.view.isHidden = true
        
        /// main image
        
        let backImgOrigin = card.convert(card.backgroundImageViewMask.frame, to: nil)
    //    let avatarOrigin = card.convert(card.authorAvatar.frame, to: nil)

        
//        PostAnimatorHelper.push(PostAnimationsTempData(mainPicOriginalFrame: backImgOrigin, avatarOriginalFrame: avatarOrigin, selectedCard: card))
        card.isHidden = true
        
        /// avatar
//        authorAvatar = UserAvatarView(frame: card.authorAvatar.frame)
//
//        if card.authorAvatar.superview == nil {
//            authorAvatar.alpha = 0
//        }
//
//        if card.authorNameLabel.superview == nil {
//            authorNameLabel.alpha = 0
//        }
//        if let image = card.authorAvatar.image {
//            authorAvatar.setImage(image)
//        }
//
       
        
//        /// title text
//        titleLabel.frame = card.titleLabel.frame
//        titleLabel.text = model.title
//        titleLabel.numberOfLines = card.titleLabel.numberOfLines
//        /// description text
//
//        descriptionLabel.frame = card.descriptionLabel.frame
//        descriptionLabel.attributedText = card.descriptionLabel.attributedText
//        descriptionLabel.numberOfLines = card.descriptionLabel.numberOfLines
//
//        /// blurredEffectView
//        blurredEffectView.frame = card.blurredEffectView.frame
//        blurredEffectView.layer.cornerRadius = card.blurredEffectView.layer.cornerRadius
//        blurredEffectView.layer.masksToBounds = true

        
   //     authorNameLabel = Text(.article, .white, card.authorNameLabel.frame)
        

        
        if model.isSelfPost {
            actionButton.setIcon(.settings)
        } else {
            actionButton.setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        }
//
//        let viewCountIcon: UIImageView = UIImageView(frame: card.viewCountIcon.frame)
//        viewCountIcon.image = Icons.eye.image()
//        let viewCountLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1),card.viewCountLabel.frame)
//        viewCountLabel.text = card.viewCountLabel.text
//        let creationDateLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1),card.creationDateLabel.frame)
//        creationDateLabel.text = card.creationDateLabel.text
//        viewCountIcon.contentMode = .scaleAspectFit
//        viewCountIcon.tintColor = #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1)
//
        /// add Subview
        backgroundImageView.frame = backImgOrigin
        backgroundImageView.layer.cornerRadius = card.backgroundImageView.layer.cornerRadius
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.image = card.backgroundImageView.image
        backgroundImageView.contentMode = .scaleAspectFill
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(titleLabel)
        blurredEffectView.contentView.addSubview(descriptionLabel)
//        containerView.addSubview(authorAvatar)
//        containerView.addSubview(authorNameLabel)
//
        backgroundImageView.addSubview(backButton)
        backgroundImageView.addSubview(actionButton)

//        backgroundImageView.addSubview(viewCountIcon)
//        backgroundImageView.addSubview(viewCountLabel)
//        backgroundImageView.addSubview(creationDateLabel)
//
//
        containerView.addSubview(toViewController.view)
        
        /// constraints
        titleLabel.easy.layout(
            Leading(25),Trailing(25),Top(20)
        )
        
        descriptionLabel.easy.layout(
            Leading(25),Trailing(25),Bottom(20),Top(3).to(titleLabel)
        )
        
//        let authorAvatarFrame = card.convert(card.authorAvatar.frame, to: nil)
//        authorAvatar.frame = authorAvatarFrame
//
//        let authorNameLabelFrame = card.convert(card.authorNameLabel.frame, to: nil)
//        authorNameLabel.frame = authorNameLabelFrame
//
        actionButton.easy.layout(Trailing(20),Top(20), Width(40), Height(40))
//        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Bottom(9).to(titleLabel))
//        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY(1).to(viewCountIcon))
//        creationDateLabel.easy.layout(Trailing(20),CenterY(1).to(viewCountIcon))
        blurredEffectView.easy.layout(Leading(15), Trailing(15), Bottom(15))

        actionButton.icon.alpha = 0
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) { [weak self] in
                self?.backgroundImageView.frame = UIScreen.main.bounds
                self?.backgroundImageView.layer.cornerRadius = 0
                self?.backButton.icon.alpha = 1
                self?.actionButton.icon.alpha = 1
//                viewCountIcon.alpha = 0
//                viewCountLabel.alpha = 0
//                creationDateLabel.alpha = 0
                containerView.layoutIfNeeded()
                
//                if self?.authorAvatar == nil && self?.authorNameLabel == nil {
//                    self?.authorAvatar.alpha = 1
//                    self?.authorNameLabel.alpha = 1
//                } else {
//                    let authorAvatarFrame = CGRect(x: 80, y: 20, width: 40, height: 40)
//                    self?.authorAvatar.frame = authorAvatarFrame
//
//
//                    self?.authorNameLabel.easy.layout(
//                        Leading(20).to(self!.authorAvatar),
//                        Trailing(20),
//                        CenterY().to(self!.authorAvatar),
//                        Height(40)
//                    )
//                }
            }
        }()
        
        animator1.startAnimation()
        animator1.addCompletion { finished in
            toViewController.view.isHidden = false
            self.backgroundImageView.removeFromSuperview()
//            self.authorAvatar.removeFromSuperview()
//            self.authorNameLabel.removeFromSuperview()
            if finished == .end {
                transitionContext.completeTransition(true)
            }
        }
    }
    
    deinit {
        print("OPEN DEINIT")
    }
}
