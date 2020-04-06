//
//  AddFilterButton.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class AddFilterButton: UICollectionViewCell, FilterItem {
   
    var onIconPress: (String) -> () = {_ in }
    
    let label : Text = Text(.article, .white)
    
    let icon : UIImageView = UIImageView(image: Icons.filter.image())
    let transparentBtn : UIButton = UIButton(type: .custom)
    
     func setup(text : String){
        addSubview(label)
        addSubview(icon)
        addSubview(transparentBtn)
        transparentBtn.backgroundColor = .clear
        transparentBtn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        
        backgroundColor = UIColor.button
        roundCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 13)
        label.text = text
        
        icon.easy.layout(CenterY(),Trailing(10),Height(15),Width(15))
        icon.isUserInteractionEnabled = false
        icon.tintColor = .white
        
        label.isUserInteractionEnabled = false
        label.easy.layout(Top(),Bottom(),Leading(15),Trailing().to(icon,.leading))
        transparentBtn.easy.layout(Top(),Bottom(),Leading(),Trailing())

        sizeToFit()
    }
    
    @objc private func btnClicked(sender: UIButton) {
        onIconPress(label.text ?? "")
    }
    
}
