//
//  RNFullscreenActivityIndicator.swift
//  round
//
//  Created by Denis Kotelnikov on 10.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//


import Foundation
import UIKit
import EasyPeasy

final class RNFullscreenActivityIndicator: UIView, RNBaseView {
    var gestureManager: RNGestureManager = RNGestureManager()
    
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.1, animations: nil)
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    let textLabel : Text = Text(.regular, .label)
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    
    init(text: String = "loading"){
        let size = UIScreen.main.bounds.size
        let frame = CGRect(origin: CGPoint(x: 0, y: -10), size: size)
        super.init(frame: frame)
        self.textLabel.text = text
    }
    
    func setupView(){
        addSubview(blur)
        addSubview(self.textLabel)
        addSubview(self.indicator)
        blur.easy.layout(Edges())
        blur.layer.masksToBounds = true
        indicator.color = .label
        indicator.startAnimating()
        indicator.easy.layout(CenterY(-20), CenterX())
        textLabel.easy.layout(Leading(), Trailing(), Top(20).to(indicator))
        textLabel.textAlignment = .center
        textLabel.sizeToFit()
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        layoutSubviews()
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.frame.origin = CGPoint(x: 0, y: 0)
        }
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
            self.frame.origin = CGPoint(x: 0, y: -10)
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { ok in
            self.removeFromSuperview()
        }
    }
    
    func updateValue(newValue: String) {
        textLabel.text = newValue
    }
    
}
