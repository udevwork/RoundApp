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
class PostEditorPhotoBlockCellModel: EditorBlockValidate {

    var image: UIImage?
    
    let onAddPhotoAddButtonPress: ( @escaping (UIImage)->() )->()
    init(onAddPhotoAddButtonPress: @escaping ( @escaping (UIImage)->() )->()){
        self.onAddPhotoAddButtonPress = onAddPhotoAddButtonPress
    }
    func validation() -> [String] {
        var requirements : [String] = []
        if image == nil {
            requirements.append("Image block")
        }
        return requirements
    }
}

// MARK: CELL ***********
class PostEditorPhotoBlockCell: UITableViewCell {
    
    var modelLink: PostEditorPhotoBlockCellModel?
    
    let backGround: UIView = UIView()
    let mainImage: UIImageView = UIImageView()
    let addMainImageButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 50, height: 50))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.gallery)
        .build()
     
    let deleteButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.systemRed)
        .setColor(.clear)
        .setIcon(.crossCircle)
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
        addSubview(backGround)
        backGround.backgroundColor = .systemGray5
        backGround.easy.layout(Edges(10))
        backGround.layer.cornerRadius = 4
        addSubview(mainImage)
        addSubview(addMainImageButton)
        
        addSubview(deleteButton)
        deleteButton.easy.layout(Trailing(40),CenterY())
        
        mainImage.contentMode = .scaleAspectFill
        mainImage.easy.layout(Edges(),Width(UIScreen.main.bounds.width),Height(UIScreen.main.bounds.width))
        addMainImageButton.easy.layout(CenterX(),CenterY(),Width(200),Height(200))
        
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
    
    override func willTransition(to state: UITableViewCell.StateMask) {

    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        deleteButton.isHidden = !editing
    }
}

