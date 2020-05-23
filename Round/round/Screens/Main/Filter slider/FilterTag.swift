//
//  FilterTag.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class FilterTag: UICollectionViewCell, FilterItem {
    var onIconPress: (String) -> () = {_ in }
    
    
    let label : Text = Text(.article, .label)
    
    let icon : Button = ButtonBuilder()
        .setStyle(.icon)
        .setIcon(.cross)
        .setIconColor(.label)
        .setColor(.clear)
        .setIconSize(CGSize(width: 12, height: 12))
        .build()
    
     func setup(text : String){
        addSubview(label)
        addSubview(icon)
        icon.onPress = { [weak self] in
            self?.onIconPress(self?.label.text ?? "")
        }
        backgroundColor = .systemGray
        
        roundCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 13)
        label.text = text
        
        icon.easy.layout(CenterY(),Trailing(10),Height(30),Width(30))
        
        label.easy.layout(Top(),Bottom(),Leading(15),Trailing().to(icon,.leading))
        sizeToFit()
    }
    
}

