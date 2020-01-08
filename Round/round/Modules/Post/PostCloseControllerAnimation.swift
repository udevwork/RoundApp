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
        let backImg : UIImageView =  UIImageView(frame: header.backgroundImageView.frame)
        backImg.layer.cornerRadius = 10
        backImg.layer.masksToBounds = true
        backImg.image = header.backgroundImageView.image
        backImg.contentMode = .scaleAspectFill
        /// title text
        let title : Text = Text(frame: header.titleLabel.frame, fontName: .Bold, size: 31)
        title.text = header.titleLabel.text
        title.numberOfLines = 1
        /// description text
        let description : Text = Text(frame: header.descriptionLabel.frame, fontName: .Regular, size: 16)
        description.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7614779538)
        let attributedString = NSMutableAttributedString(string: model.description)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        description.attributedText = attributedString
        description.numberOfLines = 3
        /// gradient
        let gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)

        /// avatar
        let authorAvatar : UserAvatarView = UserAvatarView(frame:header.authorAvatar.frame)
        authorAvatar.setImage(model.author.avatarImageURL)
        let authorNameLabel : Text = Text(frame: header.authorNameLabel.frame, fontName: .Black, size: 10)
        authorNameLabel.text = model.author.userName
        /// back btn
        let backButton : Button = ButtonBuilder()
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(Icons.back)
            .setIconSize(CGSize(width: 17, height: 17))
            .setCornerRadius(22)
            .setShadow(.NavigationBar)
            .build()
        
        /// add Subview
        containerView.addSubview(fromViewController.view)

        containerView.addSubview(backImg)
        backImg.layer.addSublayer(gradient)
        backImg.addSubview(title)
        backImg.addSubview(description)
        backImg.addSubview(authorAvatar)
        backImg.addSubview(authorNameLabel)
        backImg.addSubview(backButton)
        gradient.frame = UIScreen.main.bounds

        
        /// constraints
        title.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(description)
        )
        description.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        authorNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5293771404)
        authorAvatar.easy.layout(
            Leading(20),Top(20), Width(40), Height(40)
        )
        
        authorNameLabel.easy.layout(
            Leading(20).to(authorAvatar),
            Trailing(20),
            CenterY().to(authorAvatar),
            Height(40)
        )
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        backButton.icon.alpha = 1
        
        gradient.resizeAndMove(frame: card.gradient.bounds, animated: true, duration: 0.6)
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 10) {
                backImg.frame = card.frame
                backImg.layer.cornerRadius = 20
                backButton.icon.alpha = 0
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
