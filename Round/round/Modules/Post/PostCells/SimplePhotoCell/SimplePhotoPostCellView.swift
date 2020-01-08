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
    
    var photo : UIImageView = UIImageView(frame : CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? SimplePhotoPostCellViewModel else {print("SimplePhotoPostCellView viewModel type error"); return}
        photo.image = UIImage(named: model.imageUrl)
        setupDesign()
    }
    
    func setupDesign() {
        addSubview(photo)

        photo.contentMode = .scaleAspectFill
        photo.layer.masksToBounds = true
        photo.sizeToFit()
        photo.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Bottom() )
        layoutSubviews()
        print(photo.bounds)
    }
}
