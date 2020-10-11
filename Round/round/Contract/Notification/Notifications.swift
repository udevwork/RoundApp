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

final class Notifications {
    var top = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
    var currentNotification : RNBaseView? = nil
    public static let shared : Notifications = {
        let singletone : Notifications = Notifications()
        return singletone
    }()
    
    public func Hide(){
        currentNotification?.hide()
    }
    
    public func Show(text: String, icon: UIImage, iconColor: UIColor){
        currentNotification?.hide()
        currentNotification = RNSimpleView(text: text, icon: icon, iconColor: iconColor)
        currentNotification?.setupView()
        top.addSubview(currentNotification as! UIView)
        currentNotification?.show()
    }
    
    public func Show(_ notificationView: RNBaseView){
        DispatchQueue.main.async {
            self.currentNotification?.hide()
            self.currentNotification = notificationView
            self.currentNotification?.setupView()
            self.top.addSubview(self.currentNotification as! UIView)
            self.currentNotification?.show()
        }
    }
}

protocol RNBaseView {
    var gestureManager: RNGestureManager { get }
    var animator: UIViewPropertyAnimator { get }
    func show()
    func hide()
    func setupView()
}
