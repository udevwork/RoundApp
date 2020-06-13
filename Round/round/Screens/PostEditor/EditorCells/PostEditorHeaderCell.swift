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
class PostEditorHeaderCellModel: EditorBlockValidate {
    func validation() -> [String] {
        var requirements : [String] = []
        if image == nil{
            requirements.append("Header image")
        }
        if title == nil || title == "" || title == " "  {
            requirements.append("Header title")
        }
        if subtitle == nil || title == "" || title == " "  {
            requirements.append("Header subtitle")
        }
        return requirements
    }
    
    var title       : String?
    var subtitle    : String?
    var image       : UIImage?
    
    var location    : Location?
    var onAddPhotoAddButtonPress: (( @escaping (UIImage)->() )->())? = nil

    init(){}

}

// MARK: CELL ***********
class PostEditorHeaderCell: UITableViewCell {
    
    var modelLink: PostEditorHeaderCellModel?
    let backGround: UIView = UIView()
    private let mainImage: UIImageView = UIImageView()
     var gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.systemGray5.cgColor, UIColor.clear.cgColor], type: .axial)
    let addMainImageButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 50, height: 50))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.gallery)
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
        addSubview(backGround)
        addSubview(mainImage)
        layer.addSublayer(gradient)
        addSubview(addMainImageButton)
        addSubview(titleInputField)
        addSubview(subtitleTitleInputField)
        backGround.backgroundColor = .systemGray5
        backGround.easy.layout(Edges(10))
        backGround.layer.cornerRadius = 4
        mainImage.contentMode = .scaleAspectFill
        mainImage.easy.layout(Edges(),Width(UIScreen.main.bounds.width),Height(300))
        subtitleTitleInputField.placeholder = "subtitle"
        subtitleTitleInputField.font = FontNames.Bold.uiFont(18)
        subtitleTitleInputField.easy.layout(Bottom(29),Leading(20),Trailing(20),Height(20))
        titleInputField.placeholder = "title"
        titleInputField.font = FontNames.Bold.uiFont(23)
        titleInputField.easy.layout(Bottom(20).to(subtitleTitleInputField),Leading(20),Trailing(20),Height(25))
        addMainImageButton.easy.layout(CenterX(),CenterY(),Width(200),Height(200))
        titleInputField.autocorrectionType = .no
        subtitleTitleInputField.autocorrectionType = .no
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    public func setupWith(model: PostEditorHeaderCellModel) {
        modelLink = model
        mainImage.image = modelLink?.image
        if mainImage.image != nil {
            gradient.isHidden = false
        } else {
            gradient.isHidden = true
        }
        // TODO: fix every time layout
        layoutSubviews()
        titleInputField.text = modelLink?.title
        subtitleTitleInputField.text = modelLink?.subtitle
        addMainImageButton.setTarget { [weak self] in
            let f :  (UIImage) -> () = {[weak self] i in
                self?.mainImage.image = i
                self?.modelLink?.image = i
                self?.gradient.isHidden = false
            }
            self?.modelLink?.onAddPhotoAddButtonPress?(f)
        }
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(false, animated: false)
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
