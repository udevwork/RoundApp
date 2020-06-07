//
//  PostSaveManager.swift
//  round
//
//  Created by Denis Kotelnikov on 07.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

enum RSavePostBlockType : Int {
    case title = 0
    case simpleText = 1
    case photo = 2
}

protocol RPostBlockProtocol {
    var model: Any? { get }
    init(data: Any?)
    func save(_ reference: DocumentReference, order: Int, onSuccess:  @escaping ()->(), onFail:  @escaping ()->())
}

final class PostSaveManager {
    
    private let docRef: DocumentReference
    private let indicator: RNFullscreenActivityIndicator = RNFullscreenActivityIndicator(text: "Saving")
    private let cellData : [EditorBlockCellTypes]
    private var savingStack: [RPostBlockProtocol] = []
    private let onFinish: ()->()
    var saveProgress : Int = 0
    var currentProgress: Int = 0
    
    init(doc: CollectionReference, cellData: [EditorBlockCellTypes], onFinish: @escaping ()->()) {
        self.docRef = doc.document()
        self.onFinish = onFinish
        self.cellData = cellData
    }
    
    deinit {
        print("PostSaveManager DEINIT")
    }
    
    // MARK: Saving
    func savePost() {
        Notifications.shared.Show(indicator)
        saveProgress = cellData.count
        for i in 0...cellData.count-1 {
            // MARK: Header
            
            if case let .header(model) = cellData[i] {
                savingStack.append(RSavePostHeader(data: model))
            }
            
            // MARK: Simple text
            if case let .simpleText(model) = cellData[i] {
               savingStack.append(RSavePostSimpleText(data: model))
            }
            
            // MARK: Tile
            if case let .title(model) = cellData[i] {
                savingStack.append(RSavePostTitle(data: model))
            }
            
            // MARK: Photo
            if case let .photo(model) = cellData[i] {
                savingStack.append(RSavePostPhoto(data: model))
            }
        }
        
        for i in 0...savingStack.count-1 {
            
            savingStack[i].save(docRef, order: i, onSuccess: { [unowned self] in
                print(self.currentProgress)
                self.currentProgress += 1
                self.indicator.updateValue(newValue: "Saving [\(self.currentProgress)/\(self.saveProgress)]")
                if self.currentProgress == self.saveProgress {
                    self.onFinish()
                    Notifications.shared.Show(RNSimpleView(text: "Post Created!", icon: Icons.checkmark.image(), iconColor: .systemGreen))
                }
                }, onFail: { [unowned self] in
                    self.showErrorNotification()
                    return
            })
        }
        
    }

    private func showErrorNotification(){
        Notifications.shared.Show(RNSimpleView(text: "Post saving error", icon: Icons.xmarkOctagon.image(), iconColor: .systemRed))
    }
}

final class RSavePostPhoto: RPostBlockProtocol {
    var model: Any?
    
   required init(data: Any?) {
        self.model = data
    }
    
    func save(_ reference: DocumentReference, order: Int, onSuccess: @escaping () -> (), onFail: @escaping () -> ()) {
        
        guard let model = model as? PostEditorPhotoBlockCellModel, let image = model.image else {
            Debug.log("error: Find nil in RSavePhoto")
            return
        }
        let collectionReference: CollectionReference = reference.collection("content")
        let path = "postCards/\(String.randomString(length: 8)).jpg"
        
        FirebaseAPI.shared.uploadImage(uiImage: image, path: path) { (result, imageURL) in
            
            let dataToSend: [String : Any] = [
                "order"     : order,
                "imageUrl"  : imageURL ?? "",
                "type"      : RSavePostBlockType.photo.rawValue]
            
            collectionReference.addDocument(data: dataToSend) { error in
                if error != nil {
                    Debug.log("error: RSavePhoto: ", error as Any)
                    onFail()
                    return
                }
                onSuccess()
            }
        }
    }
}

final class RSavePostSimpleText: RPostBlockProtocol {
    var model: Any?
    
   required init(data: Any?) {
        self.model = data
    }
    
    func save(_ reference: DocumentReference, order: Int, onSuccess: @escaping () -> (), onFail: @escaping () -> ()) {
        
        guard let model = model as? PostEditorSimpleTextCellModel else {
            Debug.log("error: Find nil in RSavePostSimpleText")
            return
        }
        
        let collectionReference: CollectionReference = reference.collection("content")
        let dataToSend: [String : Any] = [
            "order" : order,
            "text"  : model.text,
            "type"  : RSavePostBlockType.simpleText.rawValue]
        
        collectionReference.addDocument(data: dataToSend) { error in
            if error != nil {
                Debug.log("error: RSavePostSimpleText: ", error as Any)
                onFail()
                return
            }
            onSuccess()
        }
    }
}

final class RSavePostTitle: RPostBlockProtocol {
    var model: Any?
    
   required init(data: Any?) {
        self.model = data
    }
    
    func save(_ reference: DocumentReference, order: Int, onSuccess: @escaping () -> (), onFail: @escaping () -> ()) {
        
        guard let model = model as? PostEditorTitleTextCellModel else {
            Debug.log("error: Find nil in RSavePostTitle")
            return
        }
        let collectionReference: CollectionReference = reference.collection("content")
                let dataToSend: [String : Any] = [
                    "order" : order,
                    "text"  : model.text,
                    "type"  : RSavePostBlockType.title.rawValue]
        
        collectionReference.addDocument(data: dataToSend) { error in
            if error != nil {
                Debug.log("error: RSavePostTitle: ", error as Any)
                onFail()
                return
            }
            onSuccess()
        }
    }
}

final class RSavePostHeader: RPostBlockProtocol {
    var model: Any?
    
    required init(data: Any?) {
        self.model = data
    }
    
    func save(_ documentReference: DocumentReference, order: Int, onSuccess: @escaping () -> (), onFail: @escaping () -> ()) {
        
        guard let model = model as? PostEditorHeaderCellModel, let image = model.image else {
            Debug.log("error: Find nil in RSavePostHeader")
            return
        }
        
        let path = "postCards/\(String.randomString(length: 8))/\(model.title ?? "").jpg"
        
        FirebaseAPI.shared.uploadImage(uiImage: image, path: path) { (result, imageURL) in
            var location: Any? = nil
            do {
                location = try FirebaseEncoder().encode(model.location)
            } catch {
                Debug.log("error: RSavePostHeader: ", error as Any)
                onFail()
                return
            }
            
            let user: [String : Any] = [
                "uid"           : AccountManager.shared.data.user?.uid as Any,
                "photoUrl"           : AccountManager.shared.data.user?.photoUrl as Any,
                "userName"           : AccountManager.shared.data.user?.userName as Any,
            ]
            
            let headerBody: [String : Any] = ["mainPicURL"       : imageURL ?? "",
                                              "author"           : user,
                                              "filterAuthorID"   : AccountManager.shared.data.user?.uid ?? "",
                                              "description"      : model.subtitle ?? "",
                                              "title"            : model.title ?? "",
                                              "xIndex"           : Int32.random(in: 1...Int32.max),
                                              "showsCount"       : 0,
                                              "viewsCount"       : 0,
                                              "creationDate"     : FieldValue.serverTimestamp(),
                                              "location"         : location ?? ""]
            
            documentReference.setData(headerBody) { error in
                if error != nil {
                    Debug.log("error: RSavePostHeader: ", error as Any)
                    onFail()
                    return
                }
                onSuccess()
            }
        }
    }
}
