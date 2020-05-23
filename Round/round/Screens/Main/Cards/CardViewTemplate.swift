//
//  CardViewTemplate.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class CardViewTemplate: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        backgroundColor = .systemFill
        layer.masksToBounds = true
        layer.cornerRadius = 13
        
    }
}
