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
    var onScreenshotPress: (Int)->() = { _ in}
    
    fileprivate lazy var postCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
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
        setupDesign(viewModel)
    }
    
    func setupDesign(_ viewModel: BasePostCellViewModelProtocol) {
        postCollectionView.easy.layout(Edges(),Height(250))
        postCollectionView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        backgroundColor = .clear
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onScreenshotPress(indexPath.row)
    }
    
    class CustomCell: UICollectionViewCell {
        let imageView : UIImageView = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            imageView.easy.layout(Edges())
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 15
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

    var hiddenCell: UIView? = nil
    
}

extension GalleryPostCellView: GalleryPagerMediaViewerDelegateProtocol {
    func pagerMedia(closed: PagerMediaViewer) {
        hiddenCell?.isHidden = false
    }
    
    func pagerMedia(frameOfImageInCell id: Int) -> CGRect? {
        
        if let cell = postCollectionView.cellForItem(at: IndexPath(row: id, section: 0)) {
            hiddenCell?.isHidden = false
            hiddenCell = cell
            hiddenCell?.isHidden = true
            let selectedFrame = postCollectionView.convert(cell.frame, to: nil)
            return selectedFrame
        } else {
            hiddenCell?.isHidden = false
            return .zero
        }
    }
    
    func pagerMedia(imageOfInDataSource id: Int) -> UIImage? {
        let iview = UIImageView()
        iview.setImage(imageURL: URL(string: urls[id]), placeholder: Images.imagePlaceholder.rawValue)
        return iview.image
    }
    
    func pagerMedia(ImagesCountFor: PagerMediaViewer) -> Int {
        return urls.count
    }
    
    
}
