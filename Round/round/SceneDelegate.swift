//
//  SceneDelegate.swift
//  round
//
//  Created by Denis Kotelnikov on 07.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import Firebase
import Purchases

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        FirebaseApp.configure()
     
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "ZvtSeixatjkoOtSlmzItkrOjIwiATNbV")
        
        let model = MainViewModel()
        let contentView = MainViewController(viewModel: model)
        
        let profile = SignInRouter.assembly(model: SignInViewModel())
        
        let tabbar = RUITabbarCountroller()
        tabbar.viewControllers = [contentView,profile]
        // let contentView = RealmTest()
        // let uitest = UITest()
        let rootNavigationController : UINavigationController = UINavigationController(rootViewController: tabbar)
        
        let navBar = rootNavigationController.navigationBar
        
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label,NSAttributedString.Key.font: FontNames.PlayRegular.uiFont(20)]
        navBar.titleTextAttributes = textAttributes
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label,NSAttributedString.Key.font: FontNames.PlayBold.uiFont(30)]
        
        navBar.barStyle = .default
        navBar.isTranslucent = true
        navBar.prefersLargeTitles = true

        ///setup Back Button
        let backImage = Icons.chevronDown.image()
        rootNavigationController.navigationBar.backIndicatorImage = backImage
        rootNavigationController.navigationBar.tintColor = .label
        
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabbar
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
