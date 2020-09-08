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
    
    lazy var avatarHeader : UserAvatarNameDate = UserAvatarNameDate(header!.avatarHeader)
    lazy var viewsCounterView : IconLabelView = IconLabelView(icon: .eye, text: "")
    lazy var bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView(header!.bottomTextBlockView)
    lazy var backgroundImageView : UIImageView = {
        let img = UIImageView()
        let backImgOrigin = UIScreen.main.bounds
        img.frame = backImgOrigin
        img.layer.cornerRadius = card!.backgroundImageView.layer.cornerRadius
        img.layer.masksToBounds = true
        img.image = card!.backgroundImageView.image
        img.contentMode = .scaleAspectFill
        img.image = header!.backgroundImageView.image
        return img
    }()
    let backButton : IconLableBluredView = IconLableBluredView(icon: .back, text: "Back")
    
    lazy var actionButton : Button = ButtonBuilder()
        .setFrame(card!.actionButton.frame)
        .setStyle(.icon)
        .setColor(.clear)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .build()
    
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
        print("fuck: ", containerView.frame)
        containerView.transform = CGAffineTransform(scaleX: fromViewController.view.transform.a, y: fromViewController.view.transform.d)
        
        toViewController.view.isHidden = false
        fromViewController.view.isHidden = true
        /// main image
        
        actionButton.setIcon(model.isSubscribed ? Icons.bookmarkfill : Icons.bookmark)
        
        /// add Subview
        containerView.addSubview(fromViewController.view)
        
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(avatarHeader)
        print("Hello", avatarHeader.frame)
        containerView.addSubview(viewsCounterView)
        backgroundImageView.addSubview(bottomTextBlockView)
        backgroundImageView.addSubview(backButton)
        backgroundImageView.addSubview(actionButton)
        actionButton.frame = header.actionButton.frame
        
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        
        avatarHeader.frame = header.convert(header.avatarHeader.frame, to: nil)
        backButton.easy.layout(Left(20),Top(20),Width(40),Height(40))
        
        actionButton.easy.layout(Trailing(20), Top(20))
        
        
        backgroundImageView.layer.cornerRadius = fromViewController.view.layer.cornerRadius
        

        let tempOriginalData = PostAnimatorHelper.pop()

        animator.addAnimations { [weak self] in
            containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.backgroundImageView.frame = tempOriginalData.mainPicOriginalFrame
            print("Save: ", tempOriginalData.avatarOriginalFrame)

            self?.avatarHeader.frame = tempOriginalData.avatarOriginalFrame
            self?.viewsCounterView.frame = tempOriginalData.viewsCounterOriginalFrame
            self?.backgroundImageView.layer.cornerRadius = card.backgroundImageView.layer.cornerRadius
            self?.backButton.alpha = 0
            self?.actionButton.alpha = 0
            self?.viewsCounterView.alpha = 1
            containerView.layoutIfNeeded()
        }
        
        animator.addCompletion { finished in
            fromViewController.view.isHidden = true
            if finished == .end {
                print("Save: ", self.avatarHeader.frame)
                
                tempOriginalData.selectedCard.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
        
        animator.startAnimation()
        
    }
    
    deinit {
        print("CLOSE DEINIT")
    }
}
