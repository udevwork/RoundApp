//
//  PostBlockSelectorViewCell.swift
//  round
//
//  Created by Denis Kotelnikov on 16.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostBlockSelectorViewCellModel{
    let blockName: String
    let blockDescription: String
    let blockIcon: UIImage
    let isBlocked: Bool

    init(_ blockName: String,_ blockDescription: String,_ blockIcon: UIImage,_ isBlocked: Bool){
        self.blockName = blockName
        self.blockDescription = blockDescription
        self.blockIcon = blockIcon
        self.isBlocked = isBlocked
    }
}

class PostBlockSelectorViewCell: UITableViewCell {
    let background : UIView = UIView()
    let blockName: Text = Text(.window, .label, .zero)
    let blockDescription: Text = Text(.article, .label, .zero)
    let blockIcon: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    private func setupView(){
        
        addSubview(background)
        addSubview(blockIcon)
        addSubview(blockName)
        addSubview(blockDescription)
        
        backgroundColor = .systemGray5
        
        background.backgroundColor = .systemGray3
        background.layer.cornerRadius = 13
        background.easy.layout(Edges(10))
        
        blockIcon.tintColor = .label
        blockIcon.easy.layout(Width(35),Height(35), CenterY(), Leading(35))
        blockIcon.contentMode = .scaleAspectFit
        
        blockName.sizeToFit()
        blockName.tintColor = .label
        blockName.easy.layout(Leading(25).to(blockIcon),Top(13),Trailing(25))
        
        blockDescription.sizeToFit()
        blockDescription.tintColor = .tertiaryLabel
        blockDescription.easy.layout(Leading(25).to(blockIcon),Top(-15).to(blockName),Trailing(25),Bottom(25))
    }
    
    func setupWith(model: PostBlockSelectorViewCellModel) {
        if model.isBlocked {
            blockIcon.alpha = 0.3
            blockName.alpha = 0.3
            blockDescription.alpha = 0.3
        } else {
            blockIcon.alpha = 1
            blockName.alpha = 1
            blockDescription.alpha = 1
        }
        blockIcon.image = model.blockIcon
        blockName.text = model.blockName
        blockDescription.text = model.blockDescription
    }
    
}
