//
//  GalleryPostCellView.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Gemini

class GalleryPostCellView: UITableViewCell, BasePostCellProtocol, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var id: String = UUID().uuidString
    var postType: PostCellType = .Gallery
    var urls: [String] = []
    
    fileprivate lazy var postCollectionView : GeminiCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 40
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collection = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.isScrollEnabled = true
        return collection
    }()
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? GalleryPostCellViewModel else {print("SimplePhotoPostCellView viewModel type error"); return}
        self.urls = model.imagesUrl ?? []
        contentView.addSubview(postCollectionView)
        postCollectionView.register(GalleryPostCellView.CustomCell.self, forCellWithReuseIdentifier: "cell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        setupDesign()
    }
    
    func setupDesign() {
        postCollectionView.easy.layout(Edges(),Height(320))
        postCollectionView.gemini
            .customAnimation()
            .alpha(0.2)
            .scale(x: 0.8, y: 0.8, z: 1)
            .rotationAngle(x: 0, y: 6, z: 0)
    }
    
    func setPadding(padding: UIEdgeInsets) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryPostCellView.CustomCell
        cell.setup(URL(string: urls[indexPath.row]))
        return cell
    }
    
    class CustomCell: GeminiCell {
        private let imageView : UIImageView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            imageView.easy.layout(Edges())
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.layer.borderColor = UIColor.systemGray6.cgColor
            imageView.layer.borderWidth = 4
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func setup(_ image: UIImage){
            self.imageView.image = image
        }
        public func setup(_ url: URL?){
            self.imageView.setImage(imageURL: url, placeholder: Images.imagePlaceholder.uiimage())
        }
    }

}

