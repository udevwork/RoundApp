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
    
    var header : PostViewControllerHeader? = nil
    var card : CardView? = nil
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil
    init(header : PostViewControllerHeader, card : CardView) {
        super.init()
        self.header = header
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        guard let header = header else {
            return
        }
        guard let card = card else {
            return
        }
        guard let model = card.viewModel else {
            return
        }
        
        guard  let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        
        toViewController.view.isHidden = false
        
        fromViewController.view.isHidden = true

        /// main image
        let backImg : UIImageView =  UIImageView(frame: UIScreen.main.bounds)
        backImg.layer.cornerRadius = 13
        backImg.layer.masksToBounds = true
        backImg.image = header.backgroundImageView.image
        backImg.contentMode = .scaleAspectFill
        /// title text
        let title : Text = Text( .title, .white, header.titleLabel.frame)
        
        title.text = header.titleLabel.text
        title.numberOfLines = 3
        /// description text
        let description : Text = Text(.article, .white, header.descriptionLabel.frame)
        
        
        let attributedString = NSMutableAttributedString(string: model.description)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        description.attributedText = attributedString
        description.numberOfLines = 3
        /// gradient
        let gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)
        
        /// avatar
        if let headerAvatar = header.authorAvatar {
            authorAvatar = UserAvatarView(frame: headerAvatar.frame)
            if let url = model.author?.photoUrl, let imageUrl = URL(string: url) {
                authorAvatar!.setImage(imageUrl)
            } else {
                authorAvatar!.setImage(Images.avatarPlaceholder.uiimage())
            }
            
        }
        
        if let headerName = header.authorNameLabel {
            authorNameLabel = Text(.article, .white, headerName.frame)
            authorNameLabel!.text = headerName.text
        }
        
        
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
        
        let saveToBookmark : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-20, y: 20), size: .zero))
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
            .setIconColor(.white)
            .setIconSize(CGSize(width: 20, height: 20))
            .build()
        
        let viewCountIcon: UIImageView = UIImageView(frame: card.viewCountIcon.frame)
        viewCountIcon.image = Icons.eye.image()
        let viewCountLabel: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42),card.viewCountLabel.frame)
        viewCountLabel.text = card.viewCountLabel.text
        let creationDateLabel: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42),card.creationDateLabel.frame)
        creationDateLabel.text = card.creationDateLabel.text
        viewCountIcon.contentMode = .scaleAspectFit
        viewCountIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42)
        
        /// add Subview
        containerView.addSubview(fromViewController.view)
        
        containerView.addSubview(backImg)
        backImg.layer.addSublayer(gradient)
        backImg.addSubview(title)
        backImg.addSubview(description)
        if authorAvatar != nil && authorNameLabel != nil {
            backImg.addSubview(authorAvatar!)
            backImg.addSubview(authorNameLabel!)
        }
        backImg.addSubview(backButton)
        backImg.addSubview(saveToBookmark)
        
        backImg.addSubview(viewCountIcon)
        backImg.addSubview(viewCountLabel)
        backImg.addSubview(creationDateLabel)
        
        gradient.frame = UIScreen.main.bounds
        
        
        /// constraints
        title.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(description)
        )
        description.easy.layout(
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
        saveToBookmark.easy.layout(Trailing(20),Top(20),Width(40),Height(40))
        saveToBookmark.icon.alpha = 1
        
        
        viewCountIcon.bounds.origin = card.viewCountLabel.frame.origin
        print(card.viewCountLabel.bounds)
        print(card.viewCountLabel.frame)
        viewCountIcon.easy.layout(Width(17), Height(17))
        viewCountLabel.bounds.origin = card.viewCountLabel.bounds.origin
        creationDateLabel.bounds = card.creationDateLabel.bounds
        
        viewCountIcon.alpha = 0
        viewCountLabel.alpha = 0
        creationDateLabel.alpha = 0
        
        gradient.resizeAndMove(frame: card.gradient.bounds, animated: true, duration: 0.6)
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
                let imgFrame = PostAnimatorHelper.pop()
                containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                backImg.frame = imgFrame
                backImg.layer.cornerRadius = 13
                backButton.icon.alpha = 0
                saveToBookmark.icon.alpha = 0
                
                if card.viewCountLabel.superview != nil {
                    viewCountIcon.alpha = 1
                    viewCountLabel.alpha = 1
                }
                
                if card.creationDateLabel.superview != nil {
                    creationDateLabel.alpha = 1
                    
                }
                
                if card.authorAvatar.superview == nil {
                    self.authorAvatar?.alpha = 0
                }
                
                if card.authorNameLabel.superview == nil {
                    self.authorNameLabel?.alpha = 0
                }
                
                containerView.layoutIfNeeded()
            }
        }()
        
        animator1.startAnimation()
        animator1.addCompletion {_ in
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
            groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.frame = frame
            add(groupAnimation, forKey: "frame")
            
        } else {
            self.frame = frame
        }
    }
}
