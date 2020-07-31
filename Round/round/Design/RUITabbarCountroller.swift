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
    var customTabBar: MenuStack = MenuStack(size: CGSize(width: 300, height: 70))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    func loadTabBar() {
        tabBar.isHidden = true
        view.addSubview(customTabBar)
        customTabBar.easy.layout(Leading(20),Trailing(20),Bottom(20),Height(70))
        
        customTabBar.append(MenuStackElement(icon: .add, onTap: {
            let vc = PostEditorRouter.assembly()
            self.present(vc, animated: true, completion: nil)
        }))
        
        customTabBar.append(MenuStackElement(icon: .house, onTap: {
            self.selectedIndex = 0
        }))
        customTabBar.append(MenuStackElement(icon: .user, onTap: {
            self.selectedIndex = 1
        }))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func setupCustomTabMenu(completion: @escaping ([UIViewController]) -> Void) {
        // handle creation of the tab bar and attach touch event listeners
    }
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
}
