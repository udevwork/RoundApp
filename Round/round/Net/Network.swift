//
//  FakeNetwork.swift
//  round
//
//  Created by Denis Kotelnikov on 17.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

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
    
    
    func fetchPostBody(id : Int, complition : ([BasePostCellViewModelProtocol])->()) {
        let result : [[BasePostCellViewModelProtocol]] = [postbody_1,postbody_2,postbody_3]
        complition(result[id])
    }
    func setCard(){
        FirebaseAPI.shared.setCard()
    }
}
