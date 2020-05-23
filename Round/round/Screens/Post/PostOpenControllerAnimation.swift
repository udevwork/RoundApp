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

class PostAnimatorHelper {
   private static var cardOriginalFrame : [CGRect] = []
    
    static func pop() -> CGRect{
       return cardOriginalFrame.removeLast()
    }
    static func push(cardFrame: CGRect){
        cardOriginalFrame.append(cardFrame)
    }
}

class PostOpenControllerAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var card : CardView? = nil
    var authorAvatar : UserAvatarView? = nil
    var authorNameLabel : Text? = nil
    init(card : CardView) {
        super.init()
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
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
        toViewController.view.layer.cornerRadius = 13
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
        let title : Text = Text(.title, .white, card.titleLabel.frame)
        title.text = model.title
        title.numberOfLines = 1
        /// description text
        let description : Text = Text(.article, .white, card.descriptionLabel.frame)
        let attributedString = NSMutableAttributedString(string: model.description)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        description.attributedText = attributedString
        description.numberOfLines = 3
        /// gradient
        let gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)
        /// avatar
        if let cardAvatar = card.authorAvatar {
            authorAvatar = UserAvatarView(frame: cardAvatar.frame)
            if let image = cardAvatar.image {
                authorAvatar!.setImage(image)
            }
        }
        if let cardName = card.authorNameLabel {
            authorNameLabel = Text(.article, .white, cardName.frame)
            authorNameLabel!.text = cardName.text
        }
        /// back btn
        let backButton : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: 0, y: 0), size: .zero))
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(.back)
            .setIconColor(.white)
            .setIconSize(CGSize(width: 20, height: 20))
            .build()
        
        let saveToBookmark : Button = ButtonBuilder()
            .setFrame(CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: .zero))
            .setStyle(.icon)
            .setColor(.clear)
            .setIcon(.bookmarkfill)
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
        saveToBookmark.easy.layout(Trailing(20),Top(20),Width(40),Height(40))
        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Bottom(9).to(title))
        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY(1).to(viewCountIcon))
        creationDateLabel.easy.layout(Trailing(20),CenterY(1).to(viewCountIcon))
        backButton.icon.alpha = 0
        saveToBookmark.icon.alpha = 0
        gradient.bounds = backImg.frame
        
        let animator1 = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
                backImg.frame = UIScreen.main.bounds
                gradient.frame = backImg.bounds
                backImg.layer.cornerRadius = 13
                backButton.icon.alpha = 1
                saveToBookmark.icon.alpha = 1
                viewCountIcon.alpha = 0
                viewCountLabel.alpha = 0
                creationDateLabel.alpha = 0
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
