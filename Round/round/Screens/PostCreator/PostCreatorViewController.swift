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
    
    private let posts = Firestore.firestore().collection("Designs")
    private var createdPostRef: DocumentReference? = nil
    
    let maintitle: String = "Acid Red"
    let maindescription: String = "Shades of red"
    let dowloadsCount: Int = 63
    let mainPicURL: String = "https://github.com/udevwork/RoundData/raw/master/AcidRed/main.png"
    
    let imagesUrl: [String] = ["https://github.com/udevwork/RoundData/raw/master/AcidRed/screen.png"]
    
    let text: String = "the package contains 31 icons of social networks and standard applications"
    let downloadLink: String = "https://github.com/udevwork/RoundData/raw/master/AcidRed/images.zip"
    let fileSize: String = "1.7 MB"
    let productID: String = "redAcidPack"
    
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
        createdPostRef = posts.document(maintitle.removingWhitespaces())
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
