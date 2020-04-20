//
//  FakeNetwork.swift
//  round
//
//  Created by Denis Kotelnikov on 17.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class Network {
    static func fetchPosts(complition : @escaping ([CardViewModel])->() ){
        
        FirebaseAPI.shared.getPostCards(count: 10) { (res, cards) in
            if res == .success {
                complition(cards!)
            } else {
                complition([])
            }
        }
    }
    
    func fetchPostBody(id : String, complition : @escaping ([BasePostCellViewModelProtocol])->()) {
        FirebaseAPI.shared.getPostBody(id: id) { res, viewModels in
            if res == .success {
                guard let viewModels = viewModels else {
                    Debug.log("Network.fetchPostBody() : ", "viewModels = nil")
                    return
                }
                complition(viewModels)
            }
        }
    }
    
    func createNewUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        FirebaseAPI.shared.createUser(email: email, password: password, complition: complition)
    }

    func signIn(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        FirebaseAPI.shared.signIn(email: email, password: password, complition: complition)
    }
        
    func signOut(complition : @escaping (HTTPResult)->()) {
        FirebaseAPI.shared.signOut(complition: complition)
    }
    
    func setUserName(name: String, complition : @escaping (HTTPResult) -> ()) {
        FirebaseAPI.shared.setUserName(name: name, complition: complition)
    }
    
    func setUserPhoto(imageUrl: String, complition : @escaping (HTTPResult) -> ()) {
        FirebaseAPI.shared.setUserPhoto(imageUrl: imageUrl, complition: complition)
    }
    
    func getUserWith(id: String, complition : @escaping (User?) -> ()) {
        FirebaseAPI.shared.getUserWith(id: id, complition: complition)
    }
    
    func uploadImage(uiImage: UIImage, complition: @escaping (HTTPResult) -> ()){
        FirebaseAPI.shared.uploadImage(uiImage: uiImage, path: AccountManager.shared.data.uid, complition: complition)
    }
   
}
