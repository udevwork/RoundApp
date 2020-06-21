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
    
    let transitionDuration: TimeInterval = 0.6
    let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7, animations: nil)
    var header : PostViewControllerHeader? = nil
    var card : CardView? = nil
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil
    
    let backgroundImageView : UIImageView = {
        let i : UIImageView =  UIImageView(frame: UIScreen.main.bounds)
        i.layer.cornerRadius = 13
        i.layer.masksToBounds = true
        i.contentMode = .scaleAspectFill
        return i
    }()
    
    /// back btn
    let backButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: CGPoint(x: 0, y: 0), size: .zero))
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(.back)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 17, height: 15))
        .setCornerRadius(13)
        .setShadow(.NavigationBar)
        .build()
    
    let bookmarkButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-20, y: 20), size: .zero))
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
    let viewCountIcon: UIImageView = {
        let i: UIImageView = UIImageView(image: Icons.eye.image())
        i.contentMode = .scaleAspectFit
        i.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42)
        return i
    }()
    
    let title: Text = {
        let t: Text = Text( .title, .white)
        t.numberOfLines = 3
        return t
    }()
    
    let descriptionLabel: Text = {
        let t: Text = Text(.article, .lightGray)
        t.numberOfLines = 3
        return t
    }()
    
    let viewCountLabel: Text = {
        let t: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42))
        return t
    }()
    
    let creationDateLabel: Text = {
        let t: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42))
        return t
    }()
    
     let gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)
    
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
        
        gradient.frame = UIScreen.main.bounds

        /// title text
        
        title.frame = header.titleLabel.frame
        title.text = header.titleLabel.text
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
        
        bookmarkButton.setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
                
        viewCountLabel.frame = card.viewCountLabel.frame
        viewCountIcon.frame = card.viewCountIcon.frame
        viewCountLabel.text = card.viewCountLabel.text
        
        creationDateLabel.frame = card.creationDateLabel.frame
        creationDateLabel.text = card.creationDateLabel.text
    
        
        /// add Subview
        containerView.addSubview(fromViewController.view)
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.layer.addSublayer(gradient)
        backgroundImageView.addSubview(title)
        backgroundImageView.addSubview(descriptionLabel)
        if authorAvatar != nil && authorNameLabel != nil {
            backgroundImageView.addSubview(authorAvatar!)
            backgroundImageView.addSubview(authorNameLabel!)
        }
        backgroundImageView.addSubview(backButton)
        backgroundImageView.addSubview(bookmarkButton)
        
        backgroundImageView.addSubview(viewCountIcon)
        backgroundImageView.addSubview(viewCountLabel)
        backgroundImageView.addSubview(creationDateLabel)
            
    
        title.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(descriptionLabel)
        )
        descriptionLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        if authorAvatar != nil && authorNameLabel != nil {
            authorAvatar!.easy.layout(
                Leading(20),Top(20), Width(40), Height(40)
            )
            
            authorNameLabel!.easy.layout(
                Leading(20).to(authorAvatar!),
                Trailing(20),
                CenterY().to(authorAvatar!),
                Height(40)
            )
        }
        
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        backButton.icon.alpha = 1
        bookmarkButton.easy.layout(Trailing(20),Top(20),Width(40),Height(40))
        bookmarkButton.icon.alpha = 1
            
        viewCountIcon.bounds.origin = card.viewCountIcon.bounds.origin

        viewCountLabel.bounds.origin = card.viewCountLabel.bounds.origin
        creationDateLabel.bounds = card.creationDateLabel.bounds
        
        viewCountIcon.alpha = 0
        viewCountLabel.alpha = 0
        creationDateLabel.alpha = 0
        
        gradient.resizeAndMove(frame: card.gradient.bounds, animated: true, duration: 0.6)
        
        animator.addAnimations { [weak self] in
            let imgFrame = PostAnimatorHelper.pop()
            containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.backgroundImageView.frame = imgFrame
            self?.backgroundImageView.layer.cornerRadius = 13
            self?.backButton.icon.alpha = 0
            self?.bookmarkButton.icon.alpha = 0
            
            if card.viewCountLabel.superview != nil {
                self?.viewCountIcon.alpha = 1
                self?.viewCountLabel.alpha = 1
            }
            
            if card.creationDateLabel.superview != nil {
                self?.creationDateLabel.alpha = 1
                
            }
            
            if card.authorAvatar.superview == nil {
                self?.authorAvatar?.alpha = 0
            }
            
            if card.authorNameLabel.superview == nil {
                self?.authorNameLabel?.alpha = 0
            }
            
            containerView.layoutIfNeeded()
        }
        
        
        animator.startAnimation()
        animator.addCompletion {_ in
            fromViewController.view.isHidden = true
            transitionContext.completeTransition(true)
        }
    }
}


extension CALayer {
    func moveTo(point: CGPoint, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = value(forKey: "position")
            animation.toValue = NSValue(cgPoint: point)
            animation.fillMode = .forwards
            self.position = point
            add(animation, forKey: "position")
        } else {
            self.position = point
        }
    }
    
    func resize(to size: CGSize, animated: Bool) {
        let oldBounds = bounds
        var newBounds = oldBounds
        newBounds.size = size
        
        if animated {
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.fromValue = NSValue(cgRect: oldBounds)
            animation.toValue = NSValue(cgRect: newBounds)
            animation.fillMode = .forwards
            self.bounds = newBounds
            add(animation, forKey: "bounds")
        } else {
            self.bounds = newBounds
        }
    }
    
    func resizeAndMove(frame: CGRect, animated: Bool, duration: TimeInterval = 0) {
        if animated {
            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = value(forKey: "position")
            positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: frame.midX, y: frame.midY))
            
            let oldBounds = bounds
            var newBounds = oldBounds
            newBounds.size = frame.size
            
            let boundsAnimation = CABasicAnimation(keyPath: "bounds")
            boundsAnimation.fromValue = NSValue(cgRect: oldBounds)
            boundsAnimation.toValue = NSValue(cgRect: newBounds)
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnimation, boundsAnimation]
            groupAnimation.fillMode = .forwards
            groupAnimation.duration = duration
            groupAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
            self.frame = frame
            add(groupAnimation, forKey: "frame")
            
        } else {
            self.frame = frame
        }
    }
}
