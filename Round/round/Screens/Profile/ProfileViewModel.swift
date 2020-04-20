//
//  ProfileViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ProfileViewModel : BaseViewModel{
    typealias routerType = ProfileRouter
    var router: ProfileRouter?
    var user: User?
    let userId: String
    var postsData: [CardViewModel]? = nil
    var postDataUpdated : Observable<[CardViewModel]?> = .init(nil)
    var userInfoUpdated : Observable<User?> = .init(nil)

    init(userId: String) {
        self.userId = userId
    }
    
    func loadUserPostsList(){
        FirebaseAPI.shared.getPostCards(userID: userId) { [weak self] result, model in
            self?.postsData = model
            self?.postDataUpdated.value = model
        }
    }
    
    func loadUserInfo(){
        FirebaseAPI.shared.getUserWith(id: userId) { [weak self] user in
            self?.user = user
            self?.userInfoUpdated.value = user
        }
    }
}
