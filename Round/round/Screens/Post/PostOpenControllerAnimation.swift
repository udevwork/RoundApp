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
    
    lazy var viewsCounterView : IconLabelView = IconLabelView(icon: .eye, text: card!.viewsCounterView.label.text!)
    lazy var bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView(card!.bottomTextBlockView)
    lazy var backgroundImageView : UIImageView = {
        let img = UIImageView()
        let backImgOrigin = card!.convert(card!.backgroundImageViewMask.frame, to: nil)
        img.frame = backImgOrigin
        img.layer.cornerRadius = card!.backgroundImageView.layer.cornerRadius
        img.layer.masksToBounds = true
        img.image = card!.backgroundImageView.image
        img.contentMode = .scaleAspectFill
        return img
    }()
    let backButton : IconLableBluredView = IconLableBluredView(icon: .back, text: "Back")
    
    init(card : CardView) {
        super.init()
        self.card = card
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    fileprivate func setupView(_ toViewController: UIViewController, _ containerView: UIView) {
        guard let card = card else { return }
        guard let model = card.viewModel else { return }
        
        toViewController.view.frame = UIScreen.main.bounds
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.isOpaque = false
        toViewController.view.layer.cornerRadius = 0
        toViewController.view.isHidden = true
        
        let backImgOrigin = card.convert(card.backgroundImageViewMask.frame, to: nil)
        let viewsCounterOrigin = card.convert(card.viewsCounterView.frame, to: nil)
        
        PostAnimatorHelper.push(PostAnimationsTempData(mainPicOriginalFrame: backImgOrigin,
                                                       viewsCounterOriginalFrame: viewsCounterOrigin,
                                                       selectedCard: card))
        
        card.isHidden = true
        backButton.alpha = 0
 
                
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(viewsCounterView)
        backgroundImageView.addSubview(bottomTextBlockView)
        backgroundImageView.addSubview(backButton)
        containerView.addSubview(toViewController.view)
        backButton.easy.layout(Leading(20),Top(20+Design.safeArea.top))
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        viewsCounterView.frame = viewsCounterOrigin
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        setupView(toViewController, containerView)
        
        let animator = {
            UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) { [weak self] in
                self?.backgroundImageView.frame = UIScreen.main.bounds
                self?.backgroundImageView.layer.cornerRadius = 0
                self?.backButton.alpha = 1
                self?.viewsCounterView.alpha = 0
                containerView.layoutIfNeeded()
                
            }
        }()
        
        animator.addCompletion { finished in
            toViewController.view.isHidden = false
            self.backgroundImageView.removeFromSuperview()
            if finished == .end {
                transitionContext.completeTransition(true)
            }
        }
        
        animator.startAnimation()
        
    }
    
    deinit {
        debugPrint("Open post animator DEINIT")
    }
}
