//
//  PostCreatorViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 07.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Firebase

class PostCreatorViewController: UIViewController {
    let table: UITableView = UITableView()
    let createHeaderButton: UIButton = UIButton()
    let deleteButton: UIButton = UIButton()
    
    private let posts = Firestore.firestore().collection("Test")
    private var createdPostRef: DocumentReference? = nil
    
    let maintitle: String = "lol"
    let maindescription: String = "kek"
    let dowloadsCount: Int = 909
    let mainPicURL: String = "https://github.com/udevwork/RoundData/raw/master/BLACK/poster.jpg"
    
    let imagesUrl: [String] = ["https://github.com/udevwork/RoundData/raw/master/BLACK/ScreenShot.jpg",
                               "https://github.com/udevwork/RoundData/raw/master/BLACK/ScreenShot.jpg",
                               "https://github.com/udevwork/RoundData/raw/master/BLACK/ScreenShot.jpg"]
    
    let text: String = "it wos added from phone"
    let downloadLink: String = "http"
    let fileSize: String = "234 kb"
    let productID: String = "id"
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGray
        
        view.addSubview(createHeaderButton)
        view.addSubview(deleteButton)
        
        createHeaderButton.easy.layout(Center())
        deleteButton.easy.layout(CenterX(), Top(10).to(createHeaderButton))
        
        
        createHeaderButton.setTitle("Create", for: .normal)
        deleteButton.setTitle("delete last", for: .normal)
        
        
        createHeaderButton.addTarget(self, action: #selector(createHeader), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteLast), for: .touchUpInside)
        
    }
    
    @objc func createHeader(){
        createdPostRef = posts.document(maintitle)
        createdPostRef?.setData(["title" : maintitle,
                                     "description" : maindescription,
                                     "dowloadsCount" : dowloadsCount,
                                     "mainPicURL" : mainPicURL]
        )
        print(createdPostRef?.documentID ?? "no created post error")
        
        let content = createdPostRef?.collection("content")
        
        // gallary
        content?.addDocument(data: [
                                "imagesUrl" : imagesUrl,
                                "order" : 0, "type" : 3])
        // arcticle
        content?.addDocument(data: [
                                "text" : text,
                                "order" : 1, "type" : 1])
        
        // download link
        content?.addDocument(data: [
                                "downloadLink" : downloadLink,
                                "fileSize" : fileSize,
                                "productID" : productID,
                                "order" : 2, "type" : 4])
    }
    
    @objc func deleteLast(){
        if let ref = createdPostRef {
            ref.delete()
        }
    }
}
