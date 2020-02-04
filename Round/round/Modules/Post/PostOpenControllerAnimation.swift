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
    
    var card : CardView? = nil
    
    
    init(card : CardView) {
        super.init()
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let card = card else {
            return
        }
        guard let model = card.viewModel else {
            return
        }
        
        guard /* let fromViewController = transitionContext.viewController(forKey: .from),*/
            let toViewController = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        
     //   let to = toViewController as! PostViewController
        
        toViewController.view.frame = UIScreen.main.bounds
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.isOpaque = false
        toViewController.view.layer.cornerRadius = 10
        toViewController.view.isHidden = true
        /// main image
        let backImg : UIImageView =  UIImageView(frame: card.frame)
        backImg.layer.cornerRadius = 13
        backImg.layer.masksToBounds = true
        backImg.image = card.backgroundImageView.image
        backImg.contentMode = .scaleAspectFill
        /// title text
        let title : Text = Text(frame: card.titleLabel.frame, fontName: .Bold, size: 31)
        title.text = model.title
        title.numberOfLines = 1
        /// description text
        let description : Text = Text(frame: card.descriptionLabel.frame, fontName: .Regular, size: 16)
        description.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7614779538)
        let attributedString = NSMutableAttributedString(string: model.description)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        description.attributedText = attributedString
        description.numberOfLines = 3
        /// gradient
        let gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.cardGradient.cgColor, UIColor.clear.cgColor], type: .axial)
        /// avatar
        let authorAvatar : UserAvatarView = UserAvatarView(frame:card.authorAvatar.frame)
        authorAvatar.setImage(model.author.avatarImageURL)
        let authorNameLabel : Text = Text(frame: card.authorNameLabel.frame, fontName: .Black, size: 10)
        authorNameLabel.text = model.author.userName
        /// back btn
        let backButton : Button = ButtonBuilder()
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(Icons.back)
            .setIconSize(CGSize(width: 17, height: 17))
            .setCornerRadius(13)
            .setShadow(.NavigationBar)
            .build()
        
        /// add Subview
        containerView.addSubview(backImg)
        backImg.layer.addSublayer(gradient)
        backImg.addSubview(title)
        backImg.addSubview(description)
        backImg.addSubview(authorAvatar)
        backImg.addSubview(authorNameLabel)
        backImg.addSubview(backButton)

        containerView.addSubview(toViewController.view)
        
        /// constraints
        title.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(description)
        )
        description.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        authorNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5293771404)
        authorAvatar.easy.layout(
            Leading(20).to(backButton),Top(20), Width(40), Height(40)
        )
        
        authorNameLabel.easy.layout(
            Leading(20).to(authorAvatar),
            Trailing(20),
            CenterY().to(authorAvatar),
            Height(40)
        )
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        backButton.icon.alpha = 0
        gradient.bounds = backImg.frame
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 10) {
                backImg.frame = UIScreen.main.bounds
                gradient.frame = backImg.bounds
                backImg.layer.cornerRadius = 13
                backButton.icon.alpha = 1
                containerView.layoutIfNeeded()
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
