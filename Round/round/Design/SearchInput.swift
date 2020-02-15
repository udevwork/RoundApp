//
//  SearchInput.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SearchInput: UIView {
    
    fileprivate let background : UIView = UIView()
    fileprivate let icon : UIImageView = UIImageView(image: Icons.search.image())
    let input : UITextField = UITextField()
  
    override init(frame : CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    fileprivate func setupView(){
        addSubview(background)
        addSubview(icon)
        addSubview(input)
        
        background.easy.layout(Top(), Bottom(), Leading(), Trailing())
        icon.easy.layout(Leading(20), CenterY(), Width(15), Height(15))
        input.easy.layout(Leading(20).to(icon), Trailing(20), Top(), Bottom())
        
        background.backgroundColor = .common
        icon.tintColor = .black
        input.backgroundColor = .clear
        input.textColor = .darkGray
        
        let placeholder = NSMutableAttributedString()
        placeholder.append(NSAttributedString(string: "Search", attributes: [.foregroundColor : UIColor.lightGray]))
        input.attributedPlaceholder = placeholder
        
        
        background.layer.masksToBounds = true
        background.layer.cornerRadius = 13
        
        input.placeholder = "Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
