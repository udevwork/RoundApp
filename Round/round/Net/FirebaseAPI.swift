//
//  FirebaseAPI.swift
//  round
//
//  Created by Denis Kotelnikov on 25.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage
import FirebaseAuth

final class FirebaseAPI : API {
    
    public static let shared : FirebaseAPI = {
        let singletone : FirebaseAPI = FirebaseAPI()
        return singletone
    }()
    
    private let posts = Firestore.firestore().collection("Designs")
    
    private init (){}
    
    func createUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Notifications.shared.Show(RNTopActivityIndicator(text: "Creating user"))
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                
            } else {
                Debug.log("error: ", error ?? "FirebaseAPI.createNewUser(...)")
                ErrorHandler().HandleAuthError(error)
                complition(HTTPResult.error, nil)
            }
        }
    }
    
    func signIn(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                Debug.log("sign in OK!")
                // complition(HTTPResult.success, user)
            } else {
                ErrorHandler().HandleAuthError(error)
                complition(.error,nil)
            }
        }
    }
    
    func signOut(complition : @escaping (HTTPResult) -> ()) {
        do {
            try Auth.auth().signOut()
            Auth.auth().signInAnonymously { res, err in
                if err == nil {
                    if let user = res?.user {
                        complition(.success)
                        Debug.log("sign out OK!")
                        Debug.log("USER ID: \(user.uid)")
                    }
                }
            }
        } catch let signOutError as NSError {
            complition(.error)
            Debug.log("Error signing out: %@", signOutError)
        }
    }
    
    
    func getPostCards(userID: String, complition : @escaping (HTTPResult, [CardViewModel]?) -> ()) {
        var arrayToReturn : [CardViewModel] = []
        posts.whereField("filterAuthorID", isEqualTo: userID).getDocuments { (snap, error) in
            if error != nil {
                Debug.log("FirebaseAPI.getPostCards(): getDocuments error: ", error ?? "nil")
                complition(HTTPResult.error, nil)
                return
            }
            
            snap?.documents.forEach({ doc in
                do {
                    
                    let result = try FirestoreDecoder().decode(PostResponse.self, from: doc.data())
                    
                    let card : CardViewModel = CardViewModel(id: doc.documentID, response: result)
                    
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
    
    
    
    func getPostCard(id: String, complition : @escaping (HTTPResult, CardViewModel?) -> ()) {
        
        posts.document(id).getDocument { doc, err in
            if err != nil {
                Debug.log("FirebaseAPI.getPostCards(): getDocuments error: ", err ?? "error")
                complition(HTTPResult.error, nil)
                return
            }
            if doc == nil {
                Debug.log("FirebaseAPI.getPostCards(): getDocuments NO DOC: ", err ?? "error")
                complition(HTTPResult.error, nil)
                return
            }
            
            do {
                let result = try FirestoreDecoder().decode(PostResponse.self, from: doc!.data()!)
                
                let card : CardViewModel = CardViewModel(id: doc!.documentID, response: result)
                
                Debug.log(card)
                complition(HTTPResult.error, card)
            } catch let error {
                Debug.log("FirebaseAPI.getPostCards(): Decoder error: ", error)
                complition(HTTPResult.error, nil)
                
            }
            
            complition(.success,nil)
        }
        
    }
    
    func getPostBody(id: String, complition: @escaping (HTTPResult, [BasePostCellViewModelProtocol]?) -> ()){
        posts.document(id).collection("content").getDocuments { (snap, error) in
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
                    case .Gallery:
                        let resp = try FirebaseDecoder().decode(GalleryPostResponse.self, from: data)
                        let vm = GalleryPostCellViewModel(model : resp)
                        models.append(vm)
                        break
                    case .Download:
                        let resp = try FirebaseDecoder().decode(DownloadPostResponse.self, from: data)
                        let vm = DownloadPostCellViewModel(model : resp)
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
    
    public func incrementPostDownloadCounter(post id: String){
        posts.document(id).updateData(["dowloadsCount" : FieldValue.increment(Int64(1))])
    }
    
    
    public func getPosts(complition : @escaping (HTTPResult, [CardViewModel]?) -> ()){
     
        posts.getDocuments { (snap, error) in
            var model : [CardViewModel] = []

            snap!.documents.forEach { doc in
                let data = doc.data()
                do {
                    let resp = try FirebaseDecoder().decode(PostResponse.self, from: data)
                    let vm = CardViewModel(id: doc.documentID, response: resp)
                    model.append(vm)
                } catch let error {
                    Debug.log("FirebaseAPI.getPostBody(): Decoder error: \(data)", error)
                    complition(HTTPResult.error, nil)
                }
            }
            complition(.success, model)
        }
       
    }
    
    // MARK: FAKE POSTS
    func GenerateFakePosts() ->  [CardViewModel] {
        
        return [CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-89.userapi.com/L4DebQB2_VxT_E7M0SQHpbNaydSXG4FNne12Kw/YRndy3wHacI.jpg", title: "Sketch App", description: "test desc", dowloadsCount: 49),
                CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-27.userapi.com/FCwVKehCCRG7L7USg3heTu0eXB55Y7UF_6uihA/-MicidUH3hI.jpg", title: "Yollo is simple", description: "test desc", dowloadsCount: 25),
                CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-17.userapi.com/4xj1TPGxiiZ0kq22dVqVa9RPbmtoHzIx6lCbSQ/LGJzdp1V5kA.jpg", title: "daily user’s needs in one hand", description: "test desc", dowloadsCount: 235),
                CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-28.userapi.com/7KI4xmTMWXpguxYSdBezONejxtzrVy5zgYMwlw/xpuW-ItMIec.jpg", title: "Your project made a great impression", description: "test desc", dowloadsCount: 2),
                CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-90.userapi.com/bGW_nINR-jkO3MKtAzq8JKk8P-Ztj5B8eVHNyw/MXbeiYKem80.jpg", title: "Good project, Awesome!", description: "test desc", dowloadsCount: 967),
                CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://sun1-95.userapi.com/aqD57_9h05HJJRplDi-_PTDdHHfltb_P6KcRxA/EwkMTmzJoPI.jpg", title: "typography", description: "test desc", dowloadsCount: 49)]
        
    }
    
    public func deletePost(postId id: String, complition : @escaping () -> ()){
        posts.document(id).delete()
        complition()
    }
}

