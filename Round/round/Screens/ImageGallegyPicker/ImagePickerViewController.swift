//
//  ImagePickerViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 10.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import Photos
import EasyPeasy

class ImagePicker: UIViewController {
    let onImageSelect: (UIImage)->()
    var photoPicker: UIImagePickerController?
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var cellModels: [IPPhotoCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.fetchPhotos()
            default:
                self.showPermisionAlert()
            }
        }
    }
    
    init(onImageSelect: @escaping (UIImage)->()) {
        self.onImageSelect = onImageSelect
        super.init(nibName: nil, bundle: nil)
        view.addSubview(collection)
        view.backgroundColor = .black
        collection.easy.layout(Edges())
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImagePickerPhotoCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
   
    func fetchPhotos() {
             
 
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
         guard let photosCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject else { return }
        
        let photosAssets = PHAsset.fetchAssets(in: photosCollection, options: fetchOptions)
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        
        photosAssets.enumerateObjects(options: []) { (asset, i, pont) in
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: options) { (img, tab) in
                self.cellModels.append(IPPhotoCellModel(img: img!, asset: asset))
            }
        }
        
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }

    private func showPermisionAlert(){
        let alert = UIAlertController(title: "Gallery", message: "permision", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "close", style: .destructive) { _ in
            alert.dismiss(animated: false, completion: nil)
        }
        let allow = UIAlertAction(title: "Allow", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(cancel)
        alert.addAction(allow)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ImagePicker: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePickerPhotoCell
        cell.setupWith(model: cellModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (view.frame.width / 4)
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PHImageManager.default().requestImage(for: cellModels[indexPath.row].asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: .none) { [weak self] (img, tab) in
            if img != nil {
                self?.onImageSelect(img!)
                self?.dismiss(animated: true, completion: nil)
            } else {
                print("NO IMAGE")
            }
        }
    }
}

class IPPhotoCellModel {
    let img: UIImage
    let asset: PHAsset
    init(img: UIImage, asset: PHAsset) {
        self.img = img
        self.asset = asset
    }
}

class ImagePickerPhotoCell: UICollectionViewCell {
    let imgView: UIImageView = UIImageView()
    var asset: PHAsset? = nil
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        imgView.contentMode = .scaleAspectFill
        addSubview(imgView)
        imgView.easy.layout(Edges())
        layer.masksToBounds = true
        layer.cornerRadius = frame.width/2
    }
    
    
    
    func setupWith(model: IPPhotoCellModel) {
        imgView.alpha = 0
        imgView.image = model.img
        self.asset = model.asset
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.imgView.alpha = 1
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
