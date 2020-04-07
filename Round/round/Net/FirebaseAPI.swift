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

class FirebaseAPI : API {
    
    public static let shared : FirebaseAPI = {
        let singletone : FirebaseAPI = FirebaseAPI()
        return singletone
    }()
    
    private let posts = Firestore.firestore().collection("posts")
    private let postBodies = Firestore.firestore().collection("postBodies")
    private let constants = Firestore.firestore().collection("Constants")
    private let users = Firestore.firestore().collection("users")
    
    
    private init (){
        
    }
    
    func createUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                debugPrint("User created!")
                complition(HTTPResult.success, User(ID: user?.user.uid, avatarImageURL: user?.user.photoURL, userName: user?.user.displayName, isAnonymus: user?.user.isAnonymous))
            } else {
                debugPrint("error: ", error ?? "FirebaseAPI.createNewUser(...)")
                complition(HTTPResult.error, nil)
            }
        }
    }
    
    func signIn(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                debugPrint("sign in OK!")
                complition(HTTPResult.success, User(ID: user?.user.uid, avatarImageURL: user?.user.photoURL, userName: user?.user.displayName, isAnonymus: user?.user.isAnonymous))
            } else {
                debugPrint("error: ", error ?? "FirebaseAPI.signIn(...)")
                complition(HTTPResult.error, nil)
            }
        }
    }
    
    func signOut(complition : @escaping (HTTPResult) -> ()) {
        do {
            try Auth.auth().signOut()
            complition(.success)
            debugPrint("sign out OK!")
        } catch let signOutError as NSError {
            complition(.error)
            debugPrint("Error signing out: %@", signOutError)
        }
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
    
    func uploadImage(uiImage: UIImage,path: String, complition: @escaping (HTTPResult) -> ()){
        let data = uiImage.jpegData(compressionQuality: 1)
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("images/\(path).jpg")
        
        let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                debugPrint("error: ", error)
                complition(.error)
                return
            }
            complition(.success)
            
            riversRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error)
                    complition(.error)
                    return
                } else {
                    print(url?.absoluteURL)
                    
                    AccountManager.shared.saveUserAvatar(imageURL: (url?.absoluteURL)!)
                    
                    complition(.success)
                }
                
            })
        }
        uploadTask.observe(.progress) { snap in
            debugPrint(snap.progress?.fractionCompleted)
        }
    }
    
    class FilterResponse : Codable{
        let Countries : [String]
    }
    
    func getCounties(complition : @escaping (HTTPResult, FilterResponse?) -> ()) {
        constants.document("Filter").getDocument { (snap, err) in
            do {
                let resp = try FirebaseDecoder().decode(FilterResponse.self, from: snap?.data() ?? [])
                complition(.success,resp)
            } catch {
                complition(.error,.none)
            }
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
