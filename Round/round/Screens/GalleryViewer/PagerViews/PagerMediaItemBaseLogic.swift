//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import EasyPeasy
import Kingfisher
import UIKit

public class PagerMediaItemBaseLogic: UIViewController, UIGestureRecognizerDelegate {
    
    enum ItemPanStatus {
        case start,
        move(CGRect),
        cancel,
        dismis
    }
    
    weak var delegate: PagerMediaViewerDelegateProtocol? = nil // needed for the interaction of the page with the controller
    
    var data: PagerMediaItemData? = nil
 
    public var targetView: UIImageView = UIImageView()
    private var saveImageSize: CGSize = .zero

    // some UI stuff
    private var scrollView: UIScrollView = UIScrollView()
    private var lastLocation: CGPoint = .zero
    private var isAnimating: Bool = false
    private var maxZoomScale: CGFloat = 1.0
    private var currentImageYOffcet: CGFloat = 0.0

    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Load view
    public func setupView() {
        
        view.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.addSubview(targetView)
        scrollView.easy.layout(Edges())
        
        targetView.contentMode = .scaleAspectFit
        updateConstraintsForSize()
        targetView.isUserInteractionEnabled = true
    }
    
    // MARK: Controller lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
    
    
    
    private func layout() {
        let size = UIScreen.main.bounds.size
        updateConstraintsForSize()
        updateMinMaxZoomScaleForSize(size)
        targetView.easy.reload()
      
    }
    
    // MARK: Gesture Recognizers
    private func addGestureRecognizers() {
        
        let panGesture = UIPanGestureRecognizer(
            target: self, action: #selector(didPan(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        targetView.addGestureRecognizer(panGesture)
        
        let pinchRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didPinch(_:)))
        pinchRecognizer.numberOfTapsRequired = 1
        pinchRecognizer.numberOfTouchesRequired = 2
        scrollView.addGestureRecognizer(pinchRecognizer)
        
        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(didSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        singleTapGesture.require(toFail: doubleTapRecognizer)
    }
    
    @objc func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard isAnimating == false, scrollView.zoomScale == scrollView.minimumZoomScale else {
            return
        }
        
        if gestureRecognizer.state == .began {
            targetView.easy.reload()
            view.layoutIfNeeded()
            lastLocation = view.center
            delegate?.pagerMediaItemPan(state: .start)
            debugPrint("transition: start image frame, ", targetView.frame)
            currentImageYOffcet = 0
        }
        
        if gestureRecognizer.state != .cancelled {
            let translation: CGPoint = gestureRecognizer.translation(in: view)
            view.center = CGPoint( x: lastLocation.x, y: lastLocation.y + translation.y)
            currentImageYOffcet = translation.y
            delegate?.pagerMediaItemPan(state: .move(getImageOriginalFrame() ?? .zero))
        }
        
        let mainViewCenter: CGPoint = CGPoint(x:self.view.bounds.midX, y:self.view.bounds.midY)
        let diffY = mainViewCenter.y - view.center.y
        if gestureRecognizer.state == .ended {
            if abs(diffY) > 60 {
                debugPrint("transition: end image frame, ", targetView.frame)
                executeDismisAnimation()
                delegate?.pagerMediaItemPan(state: .dismis)
            } else {
                debugPrint("transition: end image frame, ", targetView.frame)
                executeCancelAnimation()
                currentImageYOffcet = 0
                delegate?.pagerMediaItemPan(state: .cancel)
            }
        }
    }
    
    public func convertTargetViewFrame() -> CGRect {
        updateConstraintsForSize()
        let targetFrame = CGRect(origin: targetView.frame.origin, size: saveImageSize)
        let f = targetView.superview!.convert(targetFrame, to: nil)
        if f == .zero {
            debugPrint("transition: targetFrame: ", targetFrame)
        }
        return f
    }
    
    @objc func didPinch(_ recognizer: UITapGestureRecognizer) {
        var newZoomScale = scrollView.zoomScale / 1.5
        newZoomScale = max(newZoomScale, scrollView.minimumZoomScale)
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    @objc func didSingleTap(_ recognizer: UITapGestureRecognizer) {

    }
    
    @objc func didDoubleTap(_ recognizer:UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: targetView)
        zoomInOrOut(at: pointInView)
    }
    
    public func gestureRecognizerShouldBegin( _ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard scrollView.zoomScale == scrollView.minimumZoomScale,
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer
            else { return false }
        
        let velocity = panGesture.velocity(in: scrollView)
        return abs(velocity.y) > abs(velocity.x)
    }
    
}

// MARK: dimensions
extension PagerMediaItemBaseLogic {
    
   private func updateMinMaxZoomScaleForSize(_ size: CGSize) {
        
        let targetSize = targetView.bounds.size
        if targetSize.width == 0 || targetSize.height == 0 {
            return
        }
        
        let minScale = min(size.width/targetSize.width, size.height/targetSize.height)
        let maxScale = max(
            (size.width / 2),
            (size.height / 2))
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        maxZoomScale = maxScale
        scrollView.maximumZoomScale = maxZoomScale / 100
        targetView.easy.reload()
        view.layoutIfNeeded()
    }
    
   private func zoomInOrOut(at point:CGPoint) {
        let newZoomScale = scrollView.zoomScale == scrollView.minimumZoomScale
            ? maxZoomScale : scrollView.minimumZoomScale
        let size = scrollView.bounds.size
        let w = size.width / newZoomScale
        let h = size.height / newZoomScale
        let x = point.x - (w * 0.5)
        let y = point.y - (h * 0.5)
        let rect = CGRect(x: x, y: y, width: w, height: h)
        scrollView.zoom(to: rect, animated: true)
    }
    
    
   private func updateConstraintsForSize() {
        targetView.easy.layout(Height(UIScreen.main.bounds.height), Width(UIScreen.main.bounds.width))
        view.layoutIfNeeded()
    }

    public func getImageOriginalFrame() -> CGRect?{
        if let image = targetView.image {
            targetView.easy.layout(Leading(),Trailing(),Center())
            view.layoutIfNeeded()
            let ratio = image.size.width / image.size.height
            let newHeight = targetView.frame.width / ratio
            saveImageSize = CGSize(width: view.frame.width, height: newHeight)
            return CGRect(origin: CGPoint(x: 0, y: ((view.frame.height/2) - (newHeight/2)) + currentImageYOffcet), size: saveImageSize)
        } else {
            return nil
        }
    }
//
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if newCollection.verticalSizeClass == .compact { // to lanscape
//            targetView.easy.layout(Edges())
//             view.layoutIfNeeded()
//        } else { // to portrait
//           updateConstraintsForSize()
//        }
//    }
}

// MARK: Animation
extension PagerMediaItemBaseLogic {
    
    private func executeCancelAnimation() {
        let frameSize: CGPoint = CGPoint(x:self.view.bounds.midX, y:self.view.bounds.midY)
        self.isAnimating = true
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.view.center = frameSize
        }) {[weak self] _ in
            self?.isAnimating = false
        }
    }
    
    private func executeDismisAnimation() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
               
        }, completion: nil)
    }
}

// MARK: Scroll delegate
extension PagerMediaItemBaseLogic: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return targetView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize()
    }
}

