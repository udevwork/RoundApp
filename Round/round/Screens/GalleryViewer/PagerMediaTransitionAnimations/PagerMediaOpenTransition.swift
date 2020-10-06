//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

class PagerMediaOpenTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transitionDuration: TimeInterval = 0.25
    
    let img: UIImageView
    let imgToFrame: CGRect
    let imgFromFrame: CGRect // shold be converted to uiwindow
    let background: UIView = UIView(frame: UIScreen.main.bounds)
    
    init(img: UIImage, imgFromFrame: CGRect, imgToFrame: CGRect) {
        self.img = UIImageView(image: img)
        self.imgFromFrame = imgFromFrame
        self.imgToFrame = imgToFrame
    }
    
    private func setupView(_ toViewController: UIViewController, _ containerView: UIView){
        toViewController.view.frame = UIScreen.main.bounds
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.isOpaque = false
        toViewController.view.layer.cornerRadius = 0
        toViewController.view.isHidden = true
        containerView.addSubview(background)
        background.backgroundColor = .black
        background.alpha = 0
        containerView.addSubview(img)
        img.contentMode = .scaleAspectFit
        img.frame = imgFromFrame
        containerView.addSubview(toViewController.view)
        img.easy.layout(Edges())
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        setupView(toViewController, containerView)
        
        let animator = {
            UIViewPropertyAnimator(duration: transitionDuration, dampingRatio: 1) { [weak self] in
                self?.background.alpha = 1
                containerView.layoutIfNeeded()
            }
        }()
        
        animator.addCompletion { finished in
            self.img.removeFromSuperview()
            toViewController.view.isHidden = false
            if finished == .end {
                transitionContext.completeTransition(true)
            }
        }
        
        animator.startAnimation()
    }
    deinit {
        debugPrint("Open animator DEINIT")
    }
}
