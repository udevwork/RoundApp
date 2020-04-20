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
    private let constants = Firestore.firestore().collection("Constants")
    private let users = Firestore.firestore().collection("users")
    private let counters = Firestore.firestore().collection("Counters")
    
    private init (){
      
    }
    
    func createUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                guard let user = user?.user else {return}
                
                self.users.document(user.uid).setData(
                    ["uid": user.uid,
                     "photoUrl" : user.photoURL ?? "",
                     "userName" : user.displayName ?? ""]) { error in
                        if error != nil {
                            debugPrint(error ?? "error")
                            complition(HTTPResult.error, nil)
                        } else {
                            AccountManager.shared.data.assemblyUser()
                            complition(HTTPResult.success, AccountManager.shared.data.user)
                            debugPrint("User created!")
                        }
                }
                
                
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
                AccountManager.shared.data.assemblyUser()
                complition(HTTPResult.success, AccountManager.shared.data.user)
            } else {
                debugPrint("error: ", error ?? "FirebaseAPI.signIn(...)")
                complition(HTTPResult.error, nil)
            }
        }
    }
    
    func signOut(complition : @escaping (HTTPResult) -> ()) {
        do {
            try Auth.auth().signOut()
            AccountManager.shared.data.assemblyUser()
            complition(.success)
            debugPrint("sign out OK!")
        } catch let signOutError as NSError {
            complition(.error)
            debugPrint("Error signing out: %@", signOutError)
        }
    }
    
    func setUserName(name: String, complition : @escaping (HTTPResult) -> ()) {
        let id = AccountManager.shared.data.uid
        users.document(id).setData(["userName" : name], merge: true)
    }
    
    func setUserPhoto(imageUrl: String, complition : @escaping (HTTPResult) -> ()) {
        let id = AccountManager.shared.data.uid
        users.document(id).setData(["photoUrl" : imageUrl], merge: true)
    }
    
    func getUserWith(id: String, complition : @escaping (User?) -> ()) {
        let docRef = users.document(id)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                do {
                    guard let data = document.data() else {
                        Debug.log("FirebaseAPI.getUserWith(): NO DATA")
                        complition(nil)
                        return
                    }
                    let result = try FirebaseDecoder().decode(User.self, from: data)
                    complition(result)
                    
                } catch let error {
                    Debug.log("FirebaseAPI.getUserWith(): Decoder error: ", error)
                    complition(nil)
                    
                }
                
            } else {
                print("Document does not exist")
            }
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
                    
                    let card : CardViewModel = CardViewModel(id: doc.documentID, mainImageURL: result.mainPicURL, title: result.title, description: result.description, viewsCount: 0, authorID: result.authorID)
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
    
  func getPostCards(userID: String, complition : @escaping (HTTPResult, [CardViewModel]?) -> ()) {
      var arrayToReturn : [CardViewModel] = []
    posts.whereField("authorID", isEqualTo: userID).getDocuments { (snap, error) in
          if error != nil {
              Debug.log("FirebaseAPI.getPostCards(): getDocuments error: ", error ?? "nil")
              complition(HTTPResult.error, nil)
              return
          }
          
          snap?.documents.forEach({ doc in
              do {
                  
                  let result = try FirebaseDecoder().decode(post.self, from: doc.data())
                  
                  let card : CardViewModel = CardViewModel(id: doc.documentID, mainImageURL: result.mainPicURL, title: result.title, description: result.description, viewsCount: 0, authorID: result.authorID)
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
                let result = try FirebaseDecoder().decode(post.self, from: doc!.data())
                
                let card : CardViewModel = CardViewModel(id: doc!.documentID, mainImageURL: result.mainPicURL, title: result.title, description: result.description, viewsCount: 0, authorID: result.authorID)
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
        incrementPostView(post: id)
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
                    }
                    
                } catch let error {
                    Debug.log("FirebaseAPI.getPostBody(): Decoder error: \(data)", error)
                    complition(HTTPResult.error, nil)
                }
            }
            
            complition(HTTPResult.success, models)
        }
    }
    
    func savePost(cellData : [EditorBlockCellTypes], complition: @escaping ()->()) {
       // print(String.randomString(length: 18))
       // return
        let saveProgress : Int = cellData.count
        var currentProgress: Int = 0
        let doc = posts.document()
        incrementPostCount()

        for i in 0...cellData.count-1 {
            if case let .simpleText(model) = cellData[i] {
                saveSimpleText(doc, model, order: i) {
                    currentProgress += 1
                    print("FUCK ", currentProgress)
                    if currentProgress == saveProgress {
                        complition()
                    }
                }
            }
            if case let .header(model) = cellData[i] {
                saveHeader(doc, model){
                    currentProgress += 1
                    print("FUCK ", currentProgress)

                    if currentProgress == saveProgress {
                        complition()
                    }
                }
            }
            if case let .title(model) = cellData[i] {
                saveTitleText(doc, model, order: i){
                    currentProgress += 1
                    print("FUCK ", currentProgress)

                    if currentProgress == saveProgress {
                        complition()
                    }
                }
            }
            if case let .photo(model) = cellData[i] {
                savePhoto(doc, model, order: i){
                    currentProgress += 1
                    print("FUCK ", currentProgress)

                    if currentProgress == saveProgress {
                        complition()
                    }
                }
            }

        }

        /// Save new post id to user profile
        users.document(AccountManager.shared.data.uid).getDocument { (s, _) in
            let _posts = s?.data()!["posts"] as? [String]
            guard var posts = _posts else {
                self.users.document(AccountManager.shared.data.uid).setData(["posts" : _posts], merge: true) { _ in
                    currentProgress += 1
                    if currentProgress == saveProgress {
                        print("FUCK ", currentProgress)

                        if currentProgress == saveProgress {
                            complition()
                        }
                    }
                }
                return
            }
            posts.append(doc.documentID)
            self.users.document(AccountManager.shared.data.uid).setData(["posts" : posts], merge: true) { _ in
                currentProgress += 1
                if currentProgress == saveProgress {
                    print("FUCK ", currentProgress)

                    if currentProgress == saveProgress {
                        complition()
                    }
                }
            }
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
                    print(url?.absoluteURL as Any)
                    
                    AccountManager.shared.network.saveUserPhoto(imageUrl: (url?.absoluteURL.absoluteString)!)
                    
                    
                    complition(.success)
                }
                
            })
        }
        uploadTask.observe(.progress) { snap in
            debugPrint(snap.progress?.fractionCompleted as Any)
        }
    }
    
    func uploadCardImage(uiImage: UIImage,path: String, complition: @escaping (HTTPResult, String?) -> ()){
        let data = uiImage.jpegData(compressionQuality: 1)
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("postCards/\(path).jpg")
        
        let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                debugPrint("error: ", error)
                complition(.error, nil)
                return
            }
            
            riversRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error)
                    complition(.error, nil)
                    return
                } else {
                    print(url?.absoluteURL as Any)
                    complition(.success, url?.absoluteURL.absoluteString)
                }
                
            })
        }
        uploadTask.observe(.progress) { snap in
            debugPrint(snap.progress?.fractionCompleted as Any)
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

    
    private func saveHeader(_ doc: DocumentReference, _ data: PostEditorHeaderCellModel, complition: @escaping ()->()){
        FirebaseAPI.shared.uploadCardImage(uiImage: data.image!, path: data.title!) { (result, imageURL) in
            doc.setData(["mainPicURL" : imageURL ?? "",
                         "authorID" : AccountManager.shared.data.uid,
                         "description": data.subtitle!,
                         "title": data.title!]) { error in
                            if error == nil {
                                complition()
                            }
            }
        }
    }
    
   private func saveSimpleText(_ doc: DocumentReference, _ data: PostEditorSimpleTextCellModel, order: Int, complition: @escaping ()->()){
        let content = doc.collection("content")
        var dataToSend: [String : Any] = [:]
        dataToSend["order"] = order
        dataToSend["text"] = data.text
        dataToSend["type"] = 1
        content.addDocument(data: dataToSend) { error in
            if error != nil {
                print("SAVE POST ERROR: ",error as Any)
            } else {
                print("TEXT OK")
                complition()
            }
        }
    }
    
    private func saveTitleText(_ doc: DocumentReference, _ data: PostEditorTitleTextCellModel, order: Int, complition: @escaping ()->()){
        let content = doc.collection("content")
        var dataToSend: [String : Any] = [:]
        dataToSend["order"] = order
        dataToSend["text"] = data.text
        dataToSend["type"] = 0
        content.addDocument(data: dataToSend) { error in
            if error != nil {
                print("SAVE POST ERROR: ",error as Any)
            } else {
                print("TITLE OK")
                complition()
            }
        }
    }
    
    private func savePhoto(_ doc: DocumentReference, _ data: PostEditorPhotoBlockCellModel, order: Int, complition:  @escaping ()->()){
        let content = doc.collection("content")
        FirebaseAPI.shared.uploadCardImage(uiImage: data.image!, path: String.randomString(length: 8)) { (result, imageURL) in
            var dataToSend: [String : Any] = [:]
            dataToSend["order"] = order
            dataToSend["imageUrl"] = imageURL
            dataToSend["type"] = 2
            content.addDocument(data: dataToSend) { error in
                if error != nil {
                    print("SAVE POST ERROR: ",error as Any)
                } else {
                    print("PHOTO OK")
                    complition()
                }
            }
        }
    }
    
    public func incrementPostCount(){
        counters.document("Posts").updateData(["postCount" : FieldValue.increment(Int64(1))])
    }
    
    public func incrementPostView(post id: String){
        posts.document(id).updateData(["viewsCount" : FieldValue.increment(Int64(1))])
    }
    public func incrementUserCount(){
        counters.document("Users").updateData(["userCount" : FieldValue.increment(Int64(1))])
    }
    
//    func setCountry(){
//        constants.document("Filter").setData(["Countries":CountriesList().Countries])
//    }
    
}

struct post : Codable {
    var description: String?
    var authorID: String?
    var title: String?
    var mainPicURL: String?
    var viewsCount: Int?
}
