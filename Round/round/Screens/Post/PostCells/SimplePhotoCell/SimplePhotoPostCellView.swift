//
//  SimplePhotoPostCellView.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

import UIKit
import EasyPeasy

class SimplePhotoPostCellView: UITableViewCell, BasePostCellProtocol {
    var id: String = UUID().uuidString
    var postType: PostCellType = .SimplePhoto
    
    var photo : UIImageView = UIImageView()
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? SimplePhotoPostCellViewModel else {print("SimplePhotoPostCellView viewModel type error"); return}
        model.lazyImageLoading(model.imageUrl!, "ImagePlaceholder", { [weak self] img, type in
            if type == .url {
                self?.photo.image = img
                UIView.animate(withDuration: 0.5) {
                    self?.photo.alpha = 1
                }
            } else {
                self?.photo.alpha = 1
                self?.photo.image = img
            }
            self?.photo.sizeToFit()
            self?.photo.easy.reload()
        })
        
        setupDesign()
    }
    
    func setupDesign() {
        backgroundColor = .systemGray5
        addSubview(photo)
        photo.contentMode = .scaleAspectFill
        photo.layer.masksToBounds = true
        photo.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Bottom(),
            Height(320)
        )
        photo.alpha = 0
        layoutSubviews()
    }
}
