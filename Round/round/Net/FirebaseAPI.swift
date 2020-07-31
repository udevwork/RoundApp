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
    
    private let posts = Firestore.firestore().collection("posts")
    private let constants = Firestore.firestore().collection("Constants")
    private let users = Firestore.firestore().collection("users")
    private let counters = Firestore.firestore().collection("Counters")
    
    private init (){}
    
    func createUser(email: String, password: String, complition : @escaping (HTTPResult, User?) -> ()) {
        Notifications.shared.Show(RNTopActivityIndicator(text: "Creating user"))
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                guard let user = user?.user else { return }
                self.users.document(user.uid).setData(
                    ["uid"      : user.uid,
                     "photoUrl" : user.photoURL ?? "",
                     "userName" : user.displayName ?? ""]) { error in
                        if error != nil {
                            ErrorHandler().HandleAuthError(error)
                            complition(HTTPResult.error, nil)
                        } else {
                            AccountManager.shared.data.assemblyUser()
                            complition(HTTPResult.success, AccountManager.shared.data.user)
                            Notifications.shared.Show(RNSimpleView(text: "Welcome!", icon: Icons.user.image()))
                            Debug.log("User created!")
                        }
                }
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
                AccountManager.shared.data.assemblyUser()
                complition(HTTPResult.success, AccountManager.shared.data.user)
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
                        AccountManager.shared.network.restoreLastUserSession()
                        AccountManager.shared.data.assemblyUser()
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
    
    func setUserName(name: String, complition : @escaping (HTTPResult) -> ()) {
        let id = AccountManager.shared.data.uid
        users.document(id).setData(["userName" : name], merge: true) { error in
            if error != nil {
                complition(.error)
                return
            }
            complition(.success)
        }
        
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
                Debug.log("Document does not exist")
            }
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
    
    func getBookmarkCollection(userID: String = AccountManager.shared.data.uid, complition : @escaping (HTTPResult, [String]?) -> ()) {
            var ids : [String] = []
          posts.whereField("subscribers", arrayContains: userID).getDocuments { (snap, error) in
              if error != nil {
                  Debug.log("FirebaseAPI.getBookmarkCollection(): getDocuments error: ", error ?? "nil")
                  complition(HTTPResult.error, nil)
                  return
              }
              snap?.documents.forEach({ doc in
                      ids.append(doc.documentID)
                      complition(HTTPResult.error, nil)
              })
              complition(HTTPResult.success, ids)
              
          }
    }
    
    func getBookmarkedPostCards(userID: String, complition : @escaping (HTTPResult, [CardViewModel]?) -> ()) {
 
           var models: [CardViewModel]? = []
           posts.whereField("subscribers", arrayContains: userID).getDocuments { (snap, err) in
               if err != nil {
                   Debug.log(err as Any)
                   complition(.error, nil)
                   return
               }
               snap?.documents.forEach({ doc in
                   do {
                       let result = try FirestoreDecoder().decode(PostResponse.self, from: doc.data())
                       let card : CardViewModel = CardViewModel(id: doc.documentID, response: result )
                       models?.append(card)
                       Debug.log(result.title ?? "", result.creationDate)
                   } catch let error {
                       Debug.log("FirebaseAPI.getBookmarkedPostCards(): Decoder error: ", error)
                       complition(.error, nil)
                   }
               })
               complition(.success, models)
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
    
    private var postSaverManager: PostSaveManager? = nil
    func savePost(cellData : [EditorBlockCellTypes], complition: @escaping ()->()) {
       postSaverManager = PostSaveManager(doc: posts, cellData: cellData, onFinish: { [weak self] in
            complition()
        self?.postSaverManager = nil
        })
        postSaverManager?.savePost()
    }
    
    func uploadImage(uiImage: UIImage,path: String, complition: @escaping (HTTPResult) -> ()){
        let data = uiImage.jpegData(compressionQuality: 1)
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("images/\(path).jpg")
        let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                Debug.log("error: ", error)
                complition(.error)
                return
            }
            
            riversRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    Debug.log(error)
                    complition(.error)
                    return
                } else {
                    Debug.log(url?.absoluteURL as Any)
                    AccountManager.shared.network.saveUserPhoto(imageUrl: (url?.absoluteURL.absoluteString)!)
                    complition(.success)
                }
                
            })
        }
        uploadTask.observe(.progress) { snap in
            print(snap.progress?.fractionCompleted as Any)
          //  Debug.log(snap.progress?.fractionCompleted as Any)
            if snap.status == .success {
                
            }
        }
    }
    
    func deleteImage(){
        // TODO: Delete imageFrom firebase
        AccountManager.shared.network.saveUserPhoto(imageUrl: "")
    }
    
    func uploadImage(uiImage: UIImage,path: String, complition: @escaping (HTTPResult, String?) -> ()){
        let data = uiImage.jpegData(compressionQuality: 1)
        let storageRef = Storage.storage().reference()
        let ref = storageRef.child(path)
        
        let uploadTask = ref.putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                Debug.log("error: ", error)
                complition(.error, nil)
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    Debug.log(error)
                    complition(.error, nil)
                    return
                } else {
                    Debug.log(url?.absoluteURL as Any)
                    complition(.success, url?.absoluteURL.absoluteString)
                }
                
            })
        }
        uploadTask.observe(.progress) { snap in
            Debug.log(snap.progress?.fractionCompleted as Any)
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
        
    public func incrementPostView(post id: String){
        posts.document(id).updateData(["viewsCount" : FieldValue.increment(Int64(1))])
    }
    
    public func saveBookmark(postId id: String, complition : @escaping (HTTPResult) -> () ){
        let uid = AccountManager.shared.data.uid
        posts.document(id).setData(["subscribers" : FieldValue.arrayUnion([uid])], merge: true) { error in
            if error != nil {
                Debug.log(error as Any)
                complition(.error)
                return
            }
            complition(.success)
            //BookmarksRealmManager().save(postId: id)
         //   Notifications.shared.Show(text: "Bookmarked", icon: Icons.bookmarkfill.image(), iconColor: .systemGreen)
        }
    }
    
    public func removeBookmark(postId id: String, complition : @escaping (HTTPResult) -> ()) {
        let uid = AccountManager.shared.data.uid
        posts.document(id).setData(["subscribers" : FieldValue.arrayRemove([uid])], merge: true) { error in
            if error != nil {
                Debug.log(error as Any)
                complition(.error)
                return
            }
            complition(.success)
            //BookmarksRealmManager().remove(postId: id)
        }
    }
    
    public func getRandomPost(complition : @escaping (HTTPResult, [CardViewModel]?) -> ()){
        complition(.success,GenerateFakePosts())
        return
        
        let randomInt = Int32.random(in: 1...Int32.max)
        let res = posts.whereField("xIndex", isGreaterThanOrEqualTo: randomInt).order(by: "xIndex").limit(to: 10)
        var models: [CardViewModel]? = []
        res.getDocuments { (snap, err) in
            if err != nil {
                Debug.log(err as Any)
                complition(.error, nil)
                return
            }
            snap?.documents.forEach({ doc in
                do {
                    self.posts.document(doc.documentID).setData(["xIndex"     : Int32.random(in: 1...Int32.max),
                                                                 "showsCount" : FieldValue.increment(Int64(1))], merge: true)
                    let result = try FirestoreDecoder().decode(PostResponse.self, from: doc.data())
                    let card : CardViewModel = CardViewModel(id: doc.documentID, response: result )
                    models?.append(card)
                   // Debug.log(result.title ?? "", result.creationDate)
                } catch let error {
                    Debug.log("FirebaseAPI.getRandomPost(): Decoder error: ", error)
                    complition(.error, nil)
                }
            })
            complition(.success, models)
        }
    }
    
    // MARK: FAKE POSTS
    func GenerateFakePosts() ->  [CardViewModel] {

        let date: Timestamp = Timestamp(date: Date())
        
        let author1 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/men/32.jpg", userName: "Charley Harper")
        
        let author2 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/women/44.jpg", userName: "Bovel Filler")
        
        let author3 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/men/29.jpg", userName: "Khipers")
        
        let author4 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/men/78.jpg", userName: "Kipler Lopes")
        
        let author5 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/women/43.jpg", userName: "Ferdin Khar")
        
        let author6 = User(uid: String.randomString(length: 6), photoUrl: "https://randomuser.me/api/portraits/men/17.jpg", userName: "Lionel Lipredion")
        
        return [CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/cda33f84612027.5d62d15541aa4.jpg", title: "Sketch App", description: "test desc", viewsCount: 49, author: author1, creationDate: nil),
                CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/1400_opt_1/f7227c84612027.5d62d15542017.jpg", title: "Yollo is simple", description: "test desc", viewsCount: 25, author: author2, creationDate: date),
                CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/2863de84612027.5d62d1553f9b9.jpg", title: "daily user’s needs in one hand", description: "test desc", viewsCount: 235, author: author3, creationDate: date),
                CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/ff3f0d97338487.5ec2e4ddaad43.jpg", title: "Your project made a great impression", description: "test desc", viewsCount: 2, author: author4, creationDate: date),
                CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/33f34397338487.5ec2e4ddaa753.jpg", title: "Good project, Awesome!", description: "test desc", viewsCount: 967, author: author5, creationDate: nil),
                CardViewModel(id: "lol", mainImageURL: "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/5613a697338487.5ec2e4ddaa0fa.jpg", title: "typography", description: "test desc", viewsCount: 49, author: author6, creationDate: date)]
        
    }
    
    public func deletePost(postId id: String, complition : @escaping () -> ()){
        posts.document(id).delete()
        complition()
    }
}



