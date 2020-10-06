//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

public class PagerMediaCloseTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let transitionDuration: TimeInterval = 0.25
    
    var img: UIImageView = UIImageView()
    var imgToFrame: CGRect?
    var imgFromFrame: CGRect?
    let background: UIView = UIView(frame: UIScreen.main.bounds)
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        toViewController.view.isHidden = false
        fromViewController.view.isHidden = true
        let snapshotToView = toViewController.view.snapshotView(afterScreenUpdates: true)!
        containerView.addSubview(snapshotToView)
        containerView.addSubview(background)
        
        background.backgroundColor = .black
        background.alpha = 1
        
     
        containerView.addSubview(img)
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.frame = imgFromFrame ?? .zero
        containerView.backgroundColor = .clear
        let animator = {
            UIViewPropertyAnimator(duration: transitionDuration, dampingRatio: 1) { [weak self] in
              
                self?.img.frame = self!.imgToFrame!
                self?.img.layer.cornerRadius = 7
                self?.background.alpha = 0
            }
        }()
        
        animator.addCompletion { finished in
            if finished == .end {
                transitionContext.completeTransition(true)
            }
        }
        
        animator.startAnimation()
        
        
    }
    
    deinit {
        debugPrint("CLOSE DEINIT")
    }
}
