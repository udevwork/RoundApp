//
//  PostEditorAddNewBlockCell.swift
//  round
//
//  Created by Denis Kotelnikov on 12.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import EasyPeasy

class PostEditorAddNewBlockCellModel {
    let onAddButtonPress: ()->()
    init(onAddButtonPress: @escaping ()->()){
        self.onAddButtonPress = onAddButtonPress
    }
}

class PostEditorAddNewBlockCell: UITableViewCell {
    var onAddButtonPress: (()->())? = nil
    let backgraung: UIView = UIView()
    let addButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 45, height: 38))
        .setColor(.clear)
        .setIcon(.addPostBlock)
        .setIconColor(.systemIndigo)
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
        addSubview(backgraung)
        addSubview(addButton)
        backgraung.easy.layout(Edges(20),Width(UIScreen.main.bounds.width),Height(100))
        addButton.easy.layout(CenterX(),CenterY())
        backgraung.layer.cornerRadius = 13
        backgraung.layer.borderWidth = 2
        backgraung.layer.borderColor = UIColor.label.cgColor
    }
    
    public func setupWith(model: PostEditorAddNewBlockCellModel) {
        self.onAddButtonPress = model.onAddButtonPress
        
        addButton.setTarget { [weak self] in
            Debug.log("button press ok")
            
            self?.onAddButtonPress!()
        }
    }
}
