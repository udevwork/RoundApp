//
//  AddFilterButton.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class AddFilterButton: FilterItem {
    
    let label : Text = Text(nil, .article, .white)
    
    let icon : Button = ButtonBuilder()
        .setStyle(.icon)
        .setIcon(Icons.filter.image())
        .setIconColor(.white)
        .setColor(.clear)
        .setIconSize(CGSize(width: 13, height: 13))
        .setTarget { print("open") }
        .build()
    
    override func setup(text : String){
        addSubview(label)
        addSubview(icon)
        
        backgroundColor = UIColor.button
        roundCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 13)
        label.text = text
        
        icon.easy.layout(CenterY(),Trailing(10),Height(30),Width(30))
        
        label.easy.layout(Top(),Bottom(),Leading(15),Trailing().to(icon,.leading))
        sizeToFit()
    }
}
