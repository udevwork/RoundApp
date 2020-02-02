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
                Debug.log("FirebaseAPI.getPostCards(): getDocuments error: ", error ?? "nil")
                complition(HTTPResult.error, nil)
                return
            }
            snap?.documents.forEach({ doc in
                do {
                    let result = try FirebaseDecoder().decode(post.self, from: doc.data())
                    
                    let card : CardViewModel = CardViewModel(id: result.postBodyID ?? "", mainImageURL: result.mainPicURL, title: result.title, description: result.description, viewsCount: 0, author: nil)
                    Debug.log(card)
                    arrayToReturn.append(card)
                } catch let error {
                    Debug.log("FirebaseAPI.getPostCards(): Decoder error: ", error)
                    complition(HTTPResult.error, nil)

                }
            })
            complition(HTTPResult.success, arrayToReturn)

        }
    }
    
    func getPostBody(id: String, complition: @escaping (HTTPResult, [BasePostCellViewModelProtocol]?) -> ()){
      
        postBodies.document(id).collection("content").getDocuments { (snap, error) in
            if error != nil {
                Debug.log("FirebaseAPI.getPostBody(): getDocument error: ", error ?? "nil")
                complition(HTTPResult.error, nil)
                return
            }
           guard let snap = snap else {
                Debug.log("FirebaseAPI.getPostBody(): snap error: ", "snap == nil")
                complition(HTTPResult.error, nil)
                return
            }
            var models : [BasePostCellViewModelProtocol] = []
            snap.documents.forEach { doc in
                let type : PostCellType = PostCellType(rawValue: doc.get("type") as! Int)!
                
                 let data = doc.data()
                 do {
                    switch type {
                    case .Title :
                        let resp = try FirebaseDecoder().decode(TitlePostResponse.self, from: data)
                        let vm = TitlePostCellViewModel(model : resp)
                        models.append(vm)
                        break
                    case .Article:
                         let resp = try FirebaseDecoder().decode(ArticlePostResponse.self, from: data)
                         let vm = ArticlePostCellViewModel(model : resp)
                        models.append(vm)
                        break
                    case .SimplePhoto:
                         let resp = try FirebaseDecoder().decode(SimplePhotoResponse.self, from: data)
                         let vm = SimplePhotoPostCellViewModel(model : resp)
                        models.append(vm)
                        break
                    }
                        
                 } catch let error {
                     Debug.log("FirebaseAPI.getPostBody(): Decoder error: \(data)", error)
                     complition(HTTPResult.error, nil)
                 }
            }
            
            complition(HTTPResult.success, models)
        }
    }
    
    func setCard(){
//        let arr : [post] = [post(postBodyID: "0", description: "following", authorID: "0", title: "two")]
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
