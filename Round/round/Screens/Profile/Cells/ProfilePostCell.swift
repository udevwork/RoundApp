//
//  ProfilePostCell.swift
//  round
//
//  Created by Denis Kotelnikov on 25.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProfilePostCell: UICollectionViewCell {
    let card = CardViewProfile(viewModel: nil, frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(card)
        card.easy.layout(Top(),Bottom(),Leading(13),Trailing(13))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setup(model: CardViewModel){
        card.setupData(model)
    }
}
