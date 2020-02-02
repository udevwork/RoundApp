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
    func setCard(){
        FirebaseAPI.shared.setCard()
    }
}
