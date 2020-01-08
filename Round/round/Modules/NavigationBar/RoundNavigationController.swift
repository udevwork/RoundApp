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
    let windowTitle : Text = Text(fontName: .Medium, size: 21)
    let avatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let menuButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setIcon(Icons.menu)
        .setIconSize(CGSize(width: 17, height: 17))
        .setCornerRadius([.layerMinXMaxYCorner,.layerMinXMinYCorner], 22)
        .setShadow(.NavigationBar)
        .setTarget { print("OPEN MENU") }
        .build()
    
    let windowIconButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setIcon(Icons.location)
        .setIconSize(CGSize(width: 17, height: 17))
        .setCornerRadius(22)
        .setShadow(.NavigationBar)
        .setTarget { print("OPEN FILTER") }
        .build()
    
    let backButton : Button = ButtonBuilder()
        .setStyle(.icon)
        .setColor(.clear)
        .setIcon(Icons.back)
        .setIconSize(CGSize(width: 17, height: 17))
        .setCornerRadius(22)
        .setShadow(.NavigationBar)
        .setTarget { print("OPEN FILTER") }
        .build()
    
    
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        addSubview(windowTitle)
        addSubview(backButton)
        addSubview(avatar)
        addSubview(menuButton)
        addSubview(windowIconButton)

        backButton.setTarget {
            
        }
        
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        backgroundColor = .clear
        windowTitle.textColor = UIColor.text
        windowTitle.easy.layout(Top(),Bottom(),Leading(10).to(backButton,.trailing),Right())
        backButton.easy.layout(Left(0),CenterY(),Width(20),Height(20))
        menuButton.easy.layout(Trailing(),CenterY(),Width(44),Height(44))
        avatar.easy.layout(CenterY(),Trailing(20).to(menuButton),Width(44),Height(44))
        windowIconButton.easy.layout(CenterY(),Leading(20).to(backButton,.trailing),Width(44),Height(44))
        windowTitle.easy.layout(Top(),Bottom(),Leading(20).to(windowIconButton,.trailing),Right())
        avatar.setImage("avatar_6")
        windowTitle.textAlignment = .left
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
            UIView.animate(withDuration: 0.3, animations: {
                self.backButton.alpha = 0
                self.backButton.easy.layout(Left(0))
                self.avatar.alpha = 1
                self.avatar.easy.layout(Trailing(20).to(self.menuButton))
                self.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.backButton.alpha = 1
                self.backButton.easy.layout(Left(20))
                self.avatar.alpha = 0
                self.avatar.easy.layout(Trailing(0))
                self.layoutIfNeeded()
            })
        }
    }
    
    func transition(vc : BaseViewController<MainViewModel>) {

        UIView.transition(with: self.windowIconButton.icon, duration: 1, options: .transitionFlipFromLeft, animations: {
            self.windowIconButton.icon.image = vc.controllerIcon
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
        navBar.backButton.setTarget {
          _ = self.popViewController(animated: true)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        navBar.windowTitle.animatedTextChanging(time: 0.15, text: viewController.title ?? "")
        navBar.checkBackButton(isHidden: viewControllers.count == 1 ? true : false)
   //     navBar.transition(vc: viewController as! BaseViewController<MainViewModel>)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        navBar.windowTitle.animatedTextChanging(time: 0.15, text: viewControllers.last!.title ?? "")
        navBar.checkBackButton(isHidden: viewControllers.count == 1 ? true : false)
        navBar.transition(vc: viewControllers.last! as! BaseViewController<MainViewModel>)
        return vc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

