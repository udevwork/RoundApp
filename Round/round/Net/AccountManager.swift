//
//  AccountManager.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Firebase

class AccountManager {
    
    public static let shared : AccountManager = {
        let singletone : AccountManager = AccountManager()
        return singletone
    }()
    
    
    private init (){ }
    
    func getCurrentUser() -> User? {
        guard let fireUser = Auth.auth().currentUser else {
            debugPrint("NO USER")
            return nil
        }
        
        let user = User(ID: fireUser.uid,
                        avatarImageURL: fireUser.photoURL,
                        userName: fireUser.displayName,
                        isAnonymus: fireUser.isAnonymous)
       
        return user
    }
    
    func createNewUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Network().createNewUser(email: email, password: password, complition: complition)
    }

    func signIn(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Network().signIn(email: email, password: password, complition: complition)
    }
        
    func signOut(complition : @escaping (HTTPResult)->()) {
        Network().signOut(complition: complition)
    }
    
    func restoreLastUserSession(){
        if getCurrentUser() != nil { return }
        
        guard let email = UserDefaults.standard.string(forKey: "email"),let password =  UserDefaults.standard.string(forKey: "password") else {
            debugPrint("No saved data to login")
            debugPrint("sign In Anonymously")
            Auth.auth().signInAnonymously { res, err in
                if err == nil {
                    if let user = res?.user {
                        debugPrint("USER ID: \(user.uid)")
                    }
                }
            }
            return
        }
        
        signIn(email: email, password: password) { result, _ in
            if result == .success {
                debugPrint("Login success")
            } else {
                debugPrint("Login error. Need to autorize")
            }
        }
    }
    
    func saveUserName(newName: String) {
      let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = newName
        request?.commitChanges(completion: { error in
            debugPrint("Saved!")
        })
    }
    func saveUserAvatar(imageURL: URL) {
      let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.photoURL = imageURL
        request?.commitChanges(completion: { error in
            debugPrint("Saved new user avatar at: \(imageURL)")
        })
    }
}
