//
//  FirebaseAPI.swift
//  round
//
//  Created by Denis Kotelnikov on 25.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import CodableFirebase

class FirebaseAPI : API {
    
    public static let shared : FirebaseAPI = {
        let singletone : FirebaseAPI = FirebaseAPI()
        return singletone
    }()
    
    private let posts = Firestore.firestore().collection("posts")
    private let postBodies = Firestore.firestore().collection("postBodies")
    private let users = Firestore.firestore().collection("users")

    
    private init (){
        
    }
    
    func getPostCards(count: Int, complition : @escaping (HTTPResult, [CardViewModel]?) -> ()) {
        var arrayToReturn : [CardViewModel] = []
        posts.getDocuments { (snap, error) in
            if error != nil {
                print("you fucked-up, son")
                complition(HTTPResult.error, nil)
                return
            }
            snap?.documents.forEach({ doc in
                do {
                    let result = try FirebaseDecoder().decode(post.self, from: doc.data())
                    
                    let card : CardViewModel = CardViewModel(id: 0, mainImageURL: result.mainPicURL, title: result.title, description: result.description, viewsCount: 0, author: nil)
                    arrayToReturn.append(card)
                } catch let error {
                    print(error)
                    complition(HTTPResult.error, nil)

                }
            })
            complition(HTTPResult.success, arrayToReturn)

        }
    }
    
    func setCard(){
//        let arr : [post] = [post(postBodyID: "0", description: "following", authorID: "0", title: "two"),
//                            post(postBodyID: "0", description: "example", authorID: "0", title: "three"),
//                            post(postBodyID: "0", description: "shows", authorID: "0", title: "four"),
//                            post(postBodyID: "0", description: "how", authorID: "0", title: "five"),
//                            post(postBodyID: "0", description: "to retrieve", authorID: "0", title: "six"),
//                            post(postBodyID: "0", description: "the contents", authorID: "0", title: "seven"),
//                            post(postBodyID: "0", description: "of a single", authorID: "0", title: "eight"),
//                            post(postBodyID: "0", description: "document", authorID: "0", title: "nine"),
//                            post(postBodyID: "0", description: "using get():", authorID: "0", title: "ten"),]
//        arr.forEach { post in
//          let data = try! FirebaseEncoder().encode(post)
//
//            posts.addDocument(data: data as! [String : Any])
//        }
    }
    
}


struct post : Codable {
    var postBodyID : String?
    var description: String?
    var authorID: String?
    var title: String?
    var mainPicURL: String?
}
