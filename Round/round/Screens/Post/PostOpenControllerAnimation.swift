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
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil
    
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
        
        let backImg : UIImageView =  UIImageView()
        let x = card.convert(backImg.frame, to: nil).origin.x
        let y = card.convert(backImg.frame, to: nil).origin.y
        let imgFrame = CGRect(origin: CGPoint(x: x, y: y), size: card.frame.size)
        backImg.frame = imgFrame
        PostAnimatorHelper.push(cardFrame: imgFrame)
        backImg.layer.cornerRadius = 13
        backImg.layer.masksToBounds = true
        backImg.image = card.backgroundImageView.image
        backImg.contentMode = .scaleAspectFill
        /// title text
        let title : Text = Text(.title, .label, card.titleLabel.frame)
        title.text = model.title
        title.numberOfLines = 2
        /// description text
        let description : Text = Text(.regular, .secondaryLabel, card.descriptionLabel.frame)
        
        description.attributedText = card.descriptionLabel.attributedText
        description.numberOfLines = 2
        
        /// blurredEffectView
        let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurredEffectView.frame = card.blurredEffectView.frame
        blurredEffectView.layer.cornerRadius = 13
        blurredEffectView.layer.masksToBounds = true
        
        /// avatar
        authorAvatar = UserAvatarView(frame: card.authorAvatar.frame)
        if card.authorAvatar.superview == nil {
            authorAvatar?.alpha = 0
        }
        
        if card.authorNameLabel.superview == nil {
            authorNameLabel?.alpha = 0
        }
        if let image = card.authorAvatar.image {
            authorAvatar!.setImage(image)
        }
        
        authorNameLabel = Text(.article, .white, card.authorNameLabel.frame)
        authorNameLabel!.text = card.authorNameLabel.text
        
        /// back btn
        let backButton : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: 0, y: 0), size: .zero))
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(.back)
            .setIconColor(.white)
            .setIconSize(CGSize(width: 20, height: 20))
            .build()
        
        let actionButton : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: .zero))
            .setStyle(.icon)
            .setColor(.clear)
            .setIconColor(.white)
            .setIconSize(CGSize(width: 20, height: 20))
            .build()
        
        if model.isSelfPost {
            actionButton.setIcon(.settings)
        } else {
            actionButton.setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        }
        
        let viewCountIcon: UIImageView = UIImageView(frame: card.viewCountIcon.frame)
        viewCountIcon.image = Icons.eye.image()
        let viewCountLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1),card.viewCountLabel.frame)
        viewCountLabel.text = card.viewCountLabel.text
        let creationDateLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1),card.creationDateLabel.frame)
        creationDateLabel.text = card.creationDateLabel.text
        viewCountIcon.contentMode = .scaleAspectFit
        viewCountIcon.tintColor = #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1)
        
        /// add Subview
        containerView.addSubview(backImg)
        backImg.addSubview(blurredEffectView)
        backImg.addSubview(title)
        backImg.addSubview(description)
        if authorAvatar != nil && authorNameLabel != nil {
            backImg.addSubview(authorAvatar!)
            backImg.addSubview(authorNameLabel!)
        }
        backImg.addSubview(backButton)
        backImg.addSubview(actionButton)

        backImg.addSubview(viewCountIcon)
        backImg.addSubview(viewCountLabel)
        backImg.addSubview(creationDateLabel)

        
        containerView.addSubview(toViewController.view)
        
        /// constraints
        title.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(description)
        )
        
        description.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        if authorAvatar != nil && authorNameLabel != nil {
            
            authorAvatar!.easy.layout(
                Leading(20).to(backButton),Top(20), Width(40), Height(40)
            )
            
            authorNameLabel!.easy.layout(
                Leading(20).to(authorAvatar!),
                Trailing(20),
                CenterY().to(authorAvatar!),
                Height(40)
            )
        }
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        actionButton.easy.layout(Trailing(20),Top(20),Width(40),Height(40))
        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Bottom(9).to(title))
        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY(1).to(viewCountIcon))
        creationDateLabel.easy.layout(Trailing(20),CenterY(1).to(viewCountIcon))
         blurredEffectView.easy.layout(Leading(10), Trailing(10), Bottom(10), Top(-8).to(title,.top))
        backButton.icon.alpha = 0
        actionButton.icon.alpha = 0
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
                backImg.frame = UIScreen.main.bounds
                backImg.layer.cornerRadius = 0
                backButton.icon.alpha = 1
                actionButton.icon.alpha = 1
                viewCountIcon.alpha = 0
                viewCountLabel.alpha = 0
                creationDateLabel.alpha = 0
                containerView.layoutIfNeeded()
                
                if card.authorAvatar.superview == nil {
                    self.authorAvatar?.alpha = 1
                }
                if card.authorNameLabel.superview == nil {
                    self.authorNameLabel?.alpha = 1
                }
                
                
            }
        }()
        
        animator1.startAnimation()
        animator1.addCompletion {_ in
            toViewController.view.isHidden = false
            backImg.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
