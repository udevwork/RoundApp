//
//  PostEditorHeaderCell.swift
//  round
//
//  Created by Denis Kotelnikov on 09.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

// MARK: MODEL ***********
class PostEditorHeaderCellModel {
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    let onAddPhotoAddButtonPress: ( @escaping (UIImage)->() )->()
    init(onAddPhotoAddButtonPress: @escaping ( @escaping (UIImage)->() )->()){
        self.onAddPhotoAddButtonPress = onAddPhotoAddButtonPress
    }
}

// MARK: CELL ***********
class PostEditorHeaderCell: UITableViewCell {
    
    var modelLink: PostEditorHeaderCellModel?
 
    let mainImage: UIImageView = UIImageView()
    let addMainImageButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 50, height: 50))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(UIImage(systemName: "photo.fill.on.rectangle.fill")!)
        .build()
    
    let titleInputField: UITextField = UITextField()
    let subtitleTitleInputField: UITextField = UITextField()

 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleInputField.delegate = self
        titleInputField.tag = 1
        subtitleTitleInputField.delegate = self
        subtitleTitleInputField.tag = 2
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
        addSubview(titleInputField)
        addSubview(subtitleTitleInputField)
        mainImage.contentMode = .scaleAspectFill
        subtitleTitleInputField.placeholder = "subtitle"
        subtitleTitleInputField.font = FontNames.Bold.uiFont(18)
        titleInputField.placeholder = "title"
        titleInputField.font = FontNames.Bold.uiFont(23)
        mainImage.easy.layout(Edges(),Width(UIScreen.main.bounds.width),Height(300))
        addMainImageButton.easy.layout(CenterX(),CenterY())
        subtitleTitleInputField.easy.layout(Bottom(29),Leading(20),Trailing(20),Height(20))
        titleInputField.easy.layout(Bottom(20).to(subtitleTitleInputField),Leading(20),Trailing(20),Height(25))
    }
    
    public func setupWith(model: PostEditorHeaderCellModel) {
        modelLink = model
        mainImage.image = modelLink?.image
        titleInputField.text = modelLink?.title
        subtitleTitleInputField.text = modelLink?.subtitle
        addMainImageButton.setTarget { [weak self] in
            let f :  (UIImage) -> () = {[weak self] i in
                self?.mainImage.image = i
                self?.modelLink?.image = i
            }
            self?.modelLink?.onAddPhotoAddButtonPress(f)
        }
    }
}

extension PostEditorHeaderCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 1 {
            modelLink?.title = textField.text
        }
        if textField.tag == 2 {
            modelLink?.subtitle = textField.text
        }
    }
}
