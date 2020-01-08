//
//  SceneDelegate.swift
//  round
//
//  Created by Denis Kotelnikov on 07.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
//import FirebaseDatabase
//import FirebaseFunctions
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        
        
        let user = User(ID: 0, avatarImageURL: nil, userName: nil)
        let model = MainViewModel(user: user, cards: FakeNetwork.GetPosts())
        let contentView = MainViewController(viewModel: model)
        contentView.additionalSafeAreaInsets = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0  )

        let rootNavigationController : RoundNavigationController = RoundNavigationController(rootViewController: contentView)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootNavigationController
            
            self.window = window
            window.makeKeyAndVisible()
        }
        FirebaseApp.configure()
        
     //   ref.child("username").childByAutoId().setValue(["lol":"kek"])
//
//        ref.child("username").observeSingleEvent(of: .value) { snapshot in
//            let value = snapshot.value as? NSDictionary
//          let exp = snapshot.valueInExportFormat() as? String
//            print(exp)
//
//        }
        
//        var fireFunction = Functions.functions()
//        fireFunction.httpsCallable("myfunc").call(["text": "pizda"]) { (res, err) in
//            print(err)
//
//
//            guard let lol = (res?.data as? [String: String]) else { return }
//
//            let decoder = JSONDecoder()
//            if let data = try? JSONSerialization.data(withJSONObject: lol, options: []) {
//               let fk = try? decoder.decode(fireKek.self, from: data)
//                if let fk = fk {
//                    print(fk.text)
//                }
//            }
//        }
        
        
      //  let db = Database.database().reference()
//        let db = Firestore.firestore()
//
//        let docRef = db.collection("posts").document("mn11cuej3CA9dykInQsE")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//                document.data()?.forEach({ (key: String, value: Any) in
//                    print(key)
//                    if let res = value as? String {
//                        print(res)
//                    }
//                    if let res = value as? [String : String] {
//                        res.forEach { (key: String, value: String) in
//                            print("\(key):\(value)")
//                        }
//                    }
//
//                })
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        
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


class fireKek : Codable {
    var text : String?
    var isOk : String?
    var `operator` : String?
}
