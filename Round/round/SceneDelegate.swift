//
//  SceneDelegate.swift
//  round
//
//  Created by Denis Kotelnikov on 07.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let cards : [CardViewModel] = [
            CardViewModel(mainImageURL: "1", title: "String", description: "String", viewsCount: 0, author: nil),
            CardViewModel(mainImageURL: "2", title: "String", description: "String", viewsCount: 0, author: nil),
            CardViewModel(mainImageURL: "3", title: "String", description: "String", viewsCount: 0, author: nil),
            CardViewModel(mainImageURL: "4", title: "String", description: "String", viewsCount: 0, author: nil),
            CardViewModel(mainImageURL: "5", title: "String", description: "String", viewsCount: 0, author: nil),
            CardViewModel(mainImageURL: "6", title: "String", description: "String", viewsCount: 0, author: nil)
        ]
        let user = User(ID: 0, avatarImageURL: nil, userName: nil)
        let model = MainViewModel(user: user, cards: cards)
        let contentView = MainViewController(viewModel: model)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = contentView
            
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

