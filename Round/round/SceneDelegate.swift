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
        setupFirebase()
        setupPurchases()
        setupWindow(scene)
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        if Debug.offlineMode {
            Firestore.firestore().clearPersistence { error in
                debugPrint("Firestore.firestore().clearPersistence: error : ", error as Any)
            }
        }
    }
    
    private func setupPurchases() {

        let userID = UIDevice.current.identifierForVendor!.uuidString
        let withAPIKey = "ZvtSeixatjkoOtSlmzItkrOjIwiATNbV"
        debugPrint("userID: ", userID)

        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: withAPIKey, appUserID: userID)
        SubscriptionsViewModel.checkIfUserSubscribed()
    }
    
    fileprivate func setupWindow(_ scene: UIScene) {
        let model = MainViewModel()
        
        let contentView = MainViewController(viewModel: model)
        let iconEditor = IconEditorRouter.assembly()
        let manager = UserIconsManagerRouter.assembly(model: UserIconsManagerViewModel())
        let settings = SettingsRouter.assembly()
        
        let tabbar = RUITabbarCountroller()
        tabbar.viewControllers = [contentView, iconEditor, manager, settings]
        // let contentView = RealmTest()
        // let uitest = UITest()
        let rootNavigationController: UINavigationController = UINavigationController(rootViewController: tabbar)
        
        let navBar = rootNavigationController.navigationBar
        navBar.isTranslucent = false
        navBar.barTintColor = .systemGray6
        navBar.tintColor = .systemGray
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootNavigationController
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
