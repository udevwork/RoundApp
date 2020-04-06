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
    
    
    private init (){
        
    }
    
    func getCurrentUser() -> User {
        guard let fireUser = Auth.auth().currentUser else {
            debugPrint("NO USER")
            return User(ID: nil, avatarImageURL: nil, userName: nil, isAnonymus: nil)
        }
        let user = User(ID: fireUser.uid,
                        avatarImageURL: fireUser.photoURL,
                        userName: fireUser.displayName,
                        isAnonymus: fireUser.isAnonymous)
        return user
    }
    
    func saveUserName(newName: String) {
      let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = newName
        request?.commitChanges(completion: { error in
            debugPrint("Saved!")
        })
    }
}
