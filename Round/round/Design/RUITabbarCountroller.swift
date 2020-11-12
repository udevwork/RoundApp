//
//  RUITabbarCountroller.swift
//  round
//
//  Created by Denis Kotelnikov on 29.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class RUITabbarCountroller: UITabBarController {
    var customTabBar: MenuStack = MenuStack(size: CGSize(width: 300, height: 50))
    
    var buttons: [MenuStackElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    func loadTabBar() {
        tabBar.removeFromSuperview()
        view.addSubview(customTabBar)
        customTabBar.easy.layout(Leading(20), Trailing(20), Bottom(Design.safeArea.bottom + 30), Height(50))
        
        buttons = [MenuStackElement(icon: .house, onTap: { self.goTo(0) }),
                   MenuStackElement(icon: .iconCreator, onTap: { self.goTo(1) }),
                   MenuStackElement(icon: .folder, onTap: { self.goTo(2) }),
                   MenuStackElement(icon: .settingsGear, onTap: { self.goTo(3) })]

        buttons.forEach { customTabBar.append($0) }
        iconAnimate(0)
    }
    
    private func goTo(_ index: Int){
        if index == selectedIndex { return }
        self.selectedIndex = index
        let nextVC = selectedViewController!
        nextVC.view.frame.origin = CGPoint(x: 0, y: 20)
        nextVC.view.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            nextVC.view.alpha = 1
            nextVC.view.frame.origin = CGPoint(x: 0, y: 0)
        } completion: { (ok) in
            
        }
        iconAnimate(index)
    }
    
    private func iconAnimate(_ index: Int){
        for (i, element) in buttons.enumerated() {
            if i == index {
                UIView.animate(withDuration: 0.2) {
                    element.icon.alpha = 1
                    element.icon.layer.shadowRadius = 7
                    element.icon.layer.shadowOpacity = 0.7
                    element.icon.layer.shadowOffset = CGSize(width: 0, height: 4)
                    element.icon.layer.shadowColor = UIColor.systemIndigo.cgColor
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    element.icon.alpha = 0.3
                    element.icon.layer.shadowRadius = 0
                    element.icon.layer.shadowOpacity = 0
                    element.icon.layer.shadowOffset = CGSize(width: 0, height: 0)
                    element.icon.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
    }
}

