//
//  CardView.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit


class CardView: UIView {
    
    lazy var backgroundImageView = UIImageView()
    lazy var authorAvatarImageView = UIImageView()
    lazy var authorNameLabel : UILabel = {
        let label = UILabel()
        // TODO: setup font
        return label
    }()
    
    init(viewModel : CardViewModel, frame: CGRect) {
        super.init(frame: frame)
        setup(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup(_ viewModel : CardViewModel){
        
    }
}
