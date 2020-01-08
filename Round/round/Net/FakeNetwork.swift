//
//  FakeNetwork.swift
//  round
//
//  Created by Denis Kotelnikov on 17.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class FakeNetwork {
    static func GetPosts() -> [CardViewModel]{
        return [
            CardViewModel(id: 0, mainImageURL: "1", title: "GHOSTS", description: "I don't know why, but i like this project 'cause the colors make feel nostalgic. Great job!", viewsCount: 12, author: User(ID: nil, avatarImageURL: "avatar_0", userName: "Gethin Dougherty")),
            CardViewModel(id: 1, mainImageURL: "2", title: "MIDSOMMAR & SKATELORD", description: "Comic book published in 2019\nThe sequel to Mondo from 2017", viewsCount: 142, author: User(ID: nil, avatarImageURL: "avatar_1", userName: "Amani Mathis")),
            CardViewModel(id: 2, mainImageURL: "3", title: "Comic poster", description: "There is time for everything. To play online and to put the phone down and go play with your friends. ", viewsCount: 112, author: User(ID: nil, avatarImageURL: "avatar_2", userName: "Dillon Hussain")),
            CardViewModel(id: 3, mainImageURL: "4", title: "Bureau Oberhaeuser", description: "That’s the main message that Vivo", viewsCount: 2, author: User(ID: nil, avatarImageURL: "avatar_3", userName: "Sid Orr")),
            CardViewModel(id: 4, mainImageURL: "5", title: "Vivo", description: "Brazilian telephone carrier, wanted to transmit to the kids.", viewsCount: 1342, author: User(ID: nil, avatarImageURL: "avatar_4", userName: "Daniaal Mcleod")),
            CardViewModel(id: 5, mainImageURL: "6", title: "DEREK SWALWELL", description: "To achieve that, we went far beyond developing", viewsCount: 1, author: User(ID: nil, avatarImageURL: "avatar_5", userName: "Lucie Buckner")),
            CardViewModel(id: 6, mainImageURL: "7", title: "A unique eye.", description: "First, Violet came to life performing on a music video that combined 3D animation with miniature sets.", viewsCount: 90, author: User(ID: nil, avatarImageURL: "avatar_6", userName: "Kitty Cote")),
            CardViewModel(id: 7, mainImageURL: "8", title: "Long-standing", description: "client and collaborator", viewsCount: 142, author: User(ID: nil, avatarImageURL: "avatar_7", userName: "Ayub Ray")),
            CardViewModel(id: 8, mainImageURL: "9", title: "Derek’s identity", description: "Our refresh of Derek’s identity reflects his easy-going approach", viewsCount: 112, author: User(ID: nil, avatarImageURL: "avatar_8", userName: "Maleeha Stevens")),
            CardViewModel(id: 9, mainImageURL: "10", title: "Inspired by Derek’s love", description: "Derek’s profile as a highly respected photographer", viewsCount: 2, author: User(ID: nil, avatarImageURL: "avatar_9", userName: "Mike Estes"))
        ]
    }
    
    let postbody_1 : [BasePostCellViewModelProtocol] = [
        TitlePostCellViewModel(postType: .Title, text: "lol"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "8"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "lol")]
    
    let postbody_2 : [BasePostCellViewModelProtocol] = [
        TitlePostCellViewModel(postType: .Title, text: "lol 22222"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "lol"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "lol")]
    
    let postbody_3 : [BasePostCellViewModelProtocol] = [
        TitlePostCellViewModel(postType: .Title, text: "lol3 234"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "lol"),
        SimplePhotoPostCellViewModel(postType: .SimplePhoto, imageUrl: "2")]
    
    
    func getPostBody(id : Int, complition : ([BasePostCellViewModelProtocol])->()) {
        let result : [[BasePostCellViewModelProtocol]] = [postbody_1,postbody_2,postbody_3]
        complition(result[id])
    }
}
