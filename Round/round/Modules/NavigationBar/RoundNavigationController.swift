//
//  RoundNavigationController.swift
//  round
//
//  Created by Denis Kotelnikov on 20.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy


class RoundNavigationBar : UINavigationBar {
    let windowTitle : Text = Text(.window)
    let windowIcon : Button = ButtonBuilder()
        .setStyle(.icon)
        .setIcon(Icons.menu.image())
        .setColor(.clear)
        .setIconColor(.black)
        .setIconSize(CGSize(width: 17, height: 17))
        .setTarget { print("open") }
        .build()

    let backButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(Icons.back.image())
        .setIconColor(.black)
        .setIconSize(CGSize(width: 17, height: 15))
        .build()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(windowTitle)
        addSubview(backButton)
        addSubview(windowIcon)
        
        
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
        windowTitle.easy.layout(Top(),Bottom(),Leading().to(backButton,.trailing))
        backButton.easy.layout(Left(-10),CenterY(),Width(40),Height(40))
        windowIcon.easy.layout(Trailing(20),CenterY(),Width(44),Height(44))
        windowTitle.easy.layout(Top(),Bottom(),Leading(20),Right())
        windowTitle.textAlignment = .left
        windowTitle.sizeToFit()
        backButton.alpha = 0
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var isBackButtonHidden : Bool = true
    func checkBackButton(isHidden : Bool) {
        if isBackButtonHidden == isHidden {return}
        isBackButtonHidden = isHidden
        if isHidden == true {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else {return}
                self.backButton.alpha = 0
                self.backButton.easy.layout(Left(-10))
                self.windowTitle.easy.layout(Leading().to(self.backButton,.trailing))
                self.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else {return}
                self.backButton.alpha = 1
                self.backButton.easy.layout(Left(10))
                self.windowTitle.easy.layout(Leading().to(self.backButton,.trailing))
                self.layoutIfNeeded()
            })
        }
    }
    
    func transition(vc : NavigationDesignProtocol) {
        UIView.transition(with: self.windowIcon.icon, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.windowIcon.icon.image = vc.navIcon
        }, completion: nil)
    }
    
}


class RoundNavigationController: UINavigationController {
    
    let navBar = RoundNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        setNavigationBarHidden(true, animated: false)
        view.addSubview(navBar)
        navBar.backButton.setTarget { [weak self] in
            self?.pop()
        }
         guard let controller = viewControllers.last as? NavigationDesignProtocol else { return }
        navBar.windowTitle.text = controller.navTitle
    }
    
    func push(_ viewController: UIViewController) {
        super.pushViewController(viewController, animated: true)
        navBar.checkBackButton(isHidden: viewControllers.count == 1 ? true : false)
        guard let controller = viewController as? NavigationDesignProtocol else { return }
        navBar.transition(vc: controller )
        navBar.windowTitle.animatedTextChanging(time: 0.15, text: controller.navTitle )
        
    }
    
    func pop() {
        super.popViewController(animated: true)
        navBar.checkBackButton(isHidden: viewControllers.count == 1 ? true : false)
        guard let controller = viewControllers.last as? NavigationDesignProtocol else { return }
        navBar.transition(vc: controller )
        navBar.windowTitle.animatedTextChanging(time: 0.15, text: controller.navTitle )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

