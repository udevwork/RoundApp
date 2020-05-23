//
//  RNSimpleView.swift
//  round
//
//  Created by Denis Kotelnikov on 06.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import EasyPeasy

final class RNSimpleView: UIView, RNBaseView {
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.1, animations: nil)
    var gestureManager: RNGestureManager = RNGestureManager()
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    let textLabel : Text = Text(.regular, .label)
    let iconView: UIImageView = UIImageView()
    init(text: String, icon: UIImage, iconColor: UIColor = .label){
        let size = CGSize(width: UIScreen.main.bounds.width - 40, height: 70)
        let point = CGPoint(x: 20, y: -10)
        let frame = CGRect(origin: point, size: size)
        super.init(frame: frame)
        self.textLabel.numberOfLines = 0
        self.textLabel.text = text
        self.iconView.image = icon
        iconView.tintColor = iconColor
    }
    
    func setupView(){
        addSubview(blur)
        addSubview(self.textLabel)
        addSubview(self.iconView)
        self.layer.cornerRadius = 13
        blur.easy.layout(Edges())
        blur.layer.cornerRadius = 13
        blur.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFit
        iconView.easy.layout(CenterY(),Leading(20),Height(25),Width(25))
        textLabel.easy.layout(CenterY(),Leading(20).to(iconView), Trailing(),Top(10),Bottom(10),Height(>=40))
        gestureManager.setupGestureWith(view: self)
        gestureManager.onTapEvent = {
            self.hide()
        }
        gestureManager.onSwipeEvent = {
            self.hide()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.5) { [weak self] in
            self?.hide()
        }
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 13
        
    }
    
    
    
    func show() {
        layoutSubviews()
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.frame.origin = CGPoint(x: 20, y: 20)
        }
        
    }
    
    func hide() {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
            self.frame.origin = CGPoint(x: 20, y: -10)
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { ok in
            self.removeFromSuperview()
        }
    }
    
}
