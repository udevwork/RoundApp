//
//  ProfileViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewModel : BaseViewModel{
    typealias routerType = ProfileRouter
    var router: ProfileRouter?
    
    var postDataUpdated : SingleObservable = .init()
    var userInfoUpdated : SingleObservable = .init()
    
    var userId          : String
    var userName        : String = ""
    var userAvatar      : UIImage? = nil
    var postsData       : [CardViewModel]? = nil
    var userAvaratURL   : URL? = nil

    
    init(userId: String) {
        self.userId = userId
        loadUserInfo()
        loadPostsData()
    }
    
    func loadUserInfo(){
        FirebaseAPI.shared.getUserWith(id: userId) { [weak self] user in
            if user != nil {
                self?.userId = user?.uid ?? ""
                self?.userAvaratURL = URL(string: user!.photoUrl!)
                self?.userName = user?.userName ?? ""
                self?.userInfoUpdated.call()
            }
        }
    }
    
    func loadPostsData(){
        FirebaseAPI.shared.getPostCards(userID: userId) { [weak self] result, model in
            self?.postsData = model
            self?.postDataUpdated.call()
        }
    }
    
    func logout(completion: @escaping ()->()){
        Network().signOut { result in
            if result == .success {
                completion()
                Notifications.shared.Show(text: "logout success", icon: UIImage(named: "logout")!, iconColor: .label)
            } else {
                Notifications.shared.Show(text: "logout error", icon: UIImage(named: "logout")!, iconColor: .systemRed)
            }
        }
    }
    
    func navigateToBookmarks(){
        router?.showBookmarks()
    }
    func navigateToProfileEditor(){
        router?.showProfileEditor(delegate: self)
    }
    func navigatePostEditor(){
        router?.showPostEditor()
    }
    
}

extension ProfileViewModel: ProfileEditorDelegate {
    func profileEditor(newName: String) {
        userName = newName
        userInfoUpdated.call()
    }
    
    func profileEditor(newAvatar: UIImage) {
        userAvatar = newAvatar
        userInfoUpdated.call()
    }
    
    
}
