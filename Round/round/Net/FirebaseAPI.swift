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

final class FirebaseAPI : API {
    
    public static let shared : FirebaseAPI = {
        let singletone : FirebaseAPI = FirebaseAPI()
        return singletone
    }()
    
    private let posts = Firestore.firestore().collection("Designs")
    
    private init () {
       
    }
    
    func getPostCards(userID: String, complition : @escaping (HTTPResult, [CardViewModel]?) -> ()) {
        var arrayToReturn : [CardViewModel] = []
        posts.whereField("filterAuthorID", isEqualTo: userID).getDocuments { (snap, error) in
            if error != nil {
                debugPrint("FirebaseAPI.getPostCards(): getDocuments error: ", error ?? "nil")
                complition(HTTPResult.error, nil)
                return
            }
            
            snap?.documents.forEach({ doc in
                do {
                    
                    let result = try FirestoreDecoder().decode(PostResponse.self, from: doc.data())
                    
                    let card : CardViewModel = CardViewModel(id: doc.documentID, response: result)
                    
                    debugPrint(card)
                    arrayToReturn.append(card)
                } catch let error {
                    debugPrint("FirebaseAPI.getPostCards(): Decoder error: ", error)
                    complition(HTTPResult.error, nil)
                    
                }
            })
            complition(HTTPResult.success, arrayToReturn)
            
        }
    }
    
    
    
    func getPostCard(id: String, complition : @escaping (HTTPResult, CardViewModel?) -> ()) {
        
        posts.document(id).getDocument { doc, err in
            if err != nil {
                debugPrint("FirebaseAPI.getPostCards(): getDocuments error: ", err ?? "error")
                complition(HTTPResult.error, nil)
                return
            }
            if doc == nil {
                debugPrint("FirebaseAPI.getPostCards(): getDocuments NO DOC: ", err ?? "error")
                complition(HTTPResult.error, nil)
                return
            }
            
            do {
                let result = try FirestoreDecoder().decode(PostResponse.self, from: doc!.data()!)
                
                let card : CardViewModel = CardViewModel(id: doc!.documentID, response: result)
                
                debugPrint(card)
                complition(HTTPResult.error, card)
            } catch let error {
                debugPrint("FirebaseAPI.getPostCards(): Decoder error: ", error)
                complition(HTTPResult.error, nil)
                
            }
            
            complition(.success,nil)
        }
        
    }
    
    func getPostBody(id: String, complition: @escaping (HTTPResult, [BasePostCellViewModelProtocol]?) -> ()){
        posts.document(id).collection("content").getDocuments { [self] (snap, error) in
            if error != nil {
                debugPrint("FirebaseAPI.getPostBody(): getDocument error: ", error ?? "nil")
                complition(HTTPResult.error, nil)
                return
            }
            guard let snap = snap else {
                debugPrint("FirebaseAPI.getPostBody(): snap error: ", "snap == nil")
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
                    debugPrint("FirebaseAPI.getPostBody(): Decoder error: \(data)", error)
                    complition(HTTPResult.error, nil)
                }
            }
            
            if Debug.offlineMode {
                models.append(contentsOf: GenerateOfflinePostsBody())
            }
            
            complition(HTTPResult.success, models)
        }
    }
    
    public func incrementPostDownloadCounter(post id: String){
        posts.document(id).updateData(["dowloadsCount" : FieldValue.increment(Int64(1))])
    }
    
    public func incrementViewsCounter(post id: String){
        posts.document(id).updateData(["viewsCount" : FieldValue.increment(Int64(1))])
        debugPrint("incrementPostDownloadCounter")
    }
    
    public func getPosts(complition : @escaping (HTTPResult, [CardViewModel]?) -> ()){
     
        posts.getDocuments { [self] (snap, error) in
            var model : [CardViewModel] = []

            snap!.documents.forEach { doc in
                let data = doc.data()
                do {
                    let resp = try FirebaseDecoder().decode(PostResponse.self, from: data)
                    let vm = CardViewModel(id: doc.documentID, response: resp)
                    model.append(vm)
                } catch let error {
                    debugPrint("FirebaseAPI.getPostBody(): Decoder error: \(data)", error)
                    complition(HTTPResult.error, nil)
                }
            }
            
            if Debug.offlineMode {
                model.append(contentsOf: GenerateOfflinePosts())
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
    
    // MARK: FAKE Offline POSTS
    func GenerateOfflinePosts() ->  [CardViewModel] {
        
        return [CardViewModel(id: "AQJ0z1EQ325uW0GeLm8F", mainImageURL: "https://cdn.shopify.com/s/files/1/2252/3393/products/web_01copy_2100x.jpg?v=1601744709", title: "BLVCK", description: "Bundle Pack (3 sets in 1)", dowloadsCount: 25)]
        
    }
    
    // MARK: FAKE Offline POSTS BODY
    func GenerateOfflinePostsBody() ->  [BasePostCellViewModelProtocol] {
        var models : [BasePostCellViewModelProtocol] = []
        
        models.append(TitlePostCellViewModel(model: TitlePostResponse(type: .Title, order: 0, text: "IOS14 ICONS SET")))
        
        models.append(GalleryPostCellViewModel(model: GalleryPostResponse(type: .Gallery, order: 1, imagesUrl: [
            "https://cdn.shopify.com/s/files/1/2252/3393/products/web_02_2100x.jpg?v=1601746418",
            "https://cdn.shopify.com/s/files/1/2252/3393/products/web_03_2100x.jpg?v=1601746646",
            "https://cdn.shopify.com/s/files/1/2252/3393/products/web_04_2100x.jpg?v=1601746499",
            "https://cdn.shopify.com/s/files/1/2252/3393/products/web_05_2100x.jpg?v=1601746560"
        ])))
        
        models.append(ArticlePostCellViewModel(model: ArticlePostResponse(type: .Article, order: 2, text: """
What Is Included in each pack:

Pack 1: Blvck Monochrome Signature Set ($15)

- 140 custom icons
- 2 versions included: 70 Blvck & 70 Whte icons
- 10 complimentary Wallpapers
- Continuous updates

Pack 2: Blvck Rainbow Set ($10)

- 70 custom icons
- 10 complimentary Wallpapers
- Continuous updates

Pack 3: Blvckmoji Set ($10)

- 42 custom icons
- 10 complimentary Wallpapers
- Continuous updates

Pack 4: Bundle Pack - 3 Packs in one ($25)

- 140 Blvck MonoChrome + 70 Blvck Rainbow + 42 Blvckmoji Sets
- 10 complimentary Wallpapers
- Continuous updates
""")))
        
        models.append(DownloadPostCellViewModel(model: DownloadPostResponse(type: .Download, order: 3, downloadLink: "", fileSize: "69MB")))
        
        return models
        
    }
    
    public func deletePost(postId id: String, complition : @escaping () -> ()){
        posts.document(id).delete()
        complition()
    }
}

