//
//  PostEditorPhotoBlockCell.swift
//  round
//
//  Created by Denis Kotelnikov on 16.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//


import Foundation
import UIKit
import EasyPeasy

// MARK: MODEL ***********
class PostEditorPhotoBlockCellModel {

    var image: UIImage?
    
    let onAddPhotoAddButtonPress: ( @escaping (UIImage)->() )->()
    init(onAddPhotoAddButtonPress: @escaping ( @escaping (UIImage)->() )->()){
        self.onAddPhotoAddButtonPress = onAddPhotoAddButtonPress
    }
}

// MARK: CELL ***********
class PostEditorPhotoBlockCell: UITableViewCell {
    
    var modelLink: PostEditorPhotoBlockCellModel?
 
    let mainImage: UIImageView = UIImageView()
    let addMainImageButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 50, height: 50))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(Icons.gallery.image())
        .build()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .systemGray6
        layer.masksToBounds = true
        clipsToBounds = true
        addSubview(mainImage)
        addSubview(addMainImageButton)
        
        mainImage.contentMode = .scaleAspectFill
        mainImage.easy.layout(Edges(),Width(UIScreen.main.bounds.width),Height(UIScreen.main.bounds.width))
        addMainImageButton.easy.layout(CenterX(),CenterY())
        
    }
    
    public func setupWith(model: PostEditorPhotoBlockCellModel) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.modelLink = model
            DispatchQueue.main.async {
                self?.mainImage.image = self?.modelLink?.image
            }
            self?.addMainImageButton.setTarget { [weak self] in
                let f :  (UIImage) -> () = {[weak self] i in
                    DispatchQueue.main.async {
                    self?.mainImage.image = i
                    }
                    self?.modelLink?.image = i
                }
                self?.modelLink?.onAddPhotoAddButtonPress(f)
            }
        }
    }
}

