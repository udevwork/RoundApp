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
    
    public var data: UserDataManager = UserDataManager()
    public var network: UserRequestManager = UserRequestManager()
    
    private init (){ }

}

class UserDataManager {
    var uid: String {
        guard let user = Auth.auth().currentUser else {
            print("UserManager:uid: NO USER")
            return ""
        }
       return user.uid
    }
    var anonymous: Bool {
        guard let user = Auth.auth().currentUser else {
             print("UserManager:uid: NO USER")
             return false
         }
        return user.isAnonymous
    }
    
    var onUserChange : Observable<User?> = .init(nil)
    var user: User? = nil
    func assemblyUser() {
        guard let fireUser = Auth.auth().currentUser else {
            print("UserManager:uid: NO USER")
            return
        }
        Network().getUserWith(id: fireUser.uid) { user in
            self.user = user
            self.onUserChange.value = user
        }
    }
}

class UserRequestManager {
    
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
        if Auth.auth().currentUser == nil {
            signInAnonymously()
        }
    }
    
    private func signInAnonymously(){
        Auth.auth().signInAnonymously { res, err in
            if err == nil {
                if let user = res?.user {
                    debugPrint("USER ID: \(user.uid)")
                }
            }
        }
    }
    
    func saveUserName(newName: String) {
        Network().setUserName(name: newName) { result in
            if result == .success {
                
            } else {
                print("ERROR")
            }
        }
    }
    
    func saveUserPhoto(imageUrl: String) {
        Network().setUserPhoto(imageUrl: imageUrl) { result in
           if result == .success {
            AccountManager.shared.data.assemblyUser()
            } else {
                print("ERROR")
            }
        }
    }
}
