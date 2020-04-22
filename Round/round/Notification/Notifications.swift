//
//  Notifications.swift
//  round
//
//  Created by Denis Kotelnikov on 21.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class Notifications {
    
    private var top = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
    var anim = UIViewPropertyAnimator(duration:0.4, curve: .easeInOut, animations: nil)
    var currentNotification : UIView? = nil
    public static let shared : Notifications = {
        let singletone : Notifications = Notifications()
        return singletone
    }()
    
    private init (){
        
    }
    
    public func Show(text: String, icon: UIImage, iconColor: UIColor){
        currentNotification = SimpleNotification(text: text, icon: icon, iconColor: iconColor) {
            self.anim.addAnimations { [weak self] in
                self?.currentNotification!.easy.layout(Top(-100))
                self?.top.layoutSubviews()
            }
            self.anim.addCompletion {[weak self]  pos in
                if pos == .end {
                    self?.currentNotification!.removeFromSuperview()
                }
            }
            self.anim.startAnimation()
        }
        top.addSubview(currentNotification!)
        currentNotification!.easy.layout(Leading(20),Trailing(20),Height(70),Top(-100))
        
        top.layoutSubviews()
        anim.addAnimations { [weak self] in
            self?.currentNotification!.easy.layout(Top(10))
            self?.top.layoutSubviews()
        }
        anim.startAnimation()
    }
}


final class SimpleNotification: UIView {
    let textLabel : Text = Text(.article, .label, nil)
    let iconView: UIImageView = UIImageView()
    let ontap: ()->()
    init(text: String, icon: UIImage,iconColor: UIColor, ontap: @escaping ()->()) {
        self.ontap = ontap
        super.init(frame: .zero)
        self.layer.cornerRadius = 13
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        addSubview(blur)
        blur.alpha = 0.9
        blur.easy.layout(Edges())
        blur.layer.cornerRadius = 13
        blur.layer.masksToBounds = true
        addSubview(self.textLabel)
        addSubview(self.iconView)
        self.textLabel.text = text
        self.iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = iconColor
        textLabel.sizeToFit()
        iconView.easy.layout(CenterY(),Leading(20),Height(30),Width(30))
        textLabel.easy.layout(CenterY(),Leading(20).to(iconView), Trailing(),Top(10),Bottom(10),Height(>=40))
       
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
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
    
    @objc func tap(){
        ontap()
    }
}
