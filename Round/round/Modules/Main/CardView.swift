//
//  CardView.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardView: UIView {
    
    lazy var backgroundImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var authorAvatarImageView = UIImageView()
    lazy var authorNameLabel = UILabel()
    
    init(viewModel : CardViewModel, frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
        setupData(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupDesign(){
        [backgroundImageView, titleLabel, descriptionLabel, authorAvatarImageView, authorNameLabel].forEach {
            addSubview($0)
        }
        layer.cornerRadius = 20
        backgroundImageView.layer.cornerRadius = 20
        backgroundImageView.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageView.contentMode = .scaleAspectFill
        
        titleLabel.easy.layout(
         Leading(),Trailing(),Bottom(),Height(40)
        )
        descriptionLabel.easy.layout(
         Leading(),Trailing(),Bottom(),Height(40)
        )
        authorAvatarImageView.easy.layout(
         Leading(),Bottom(),Height(40),Width(40)
        )
        authorNameLabel.easy.layout(
            Leading().to(authorAvatarImageView,.trailing),
            Trailing(),
            CenterY().to(authorAvatarImageView),
            Height(40)
        )
    }
    
    fileprivate func setupData(_ viewModel : CardViewModel){
        backgroundImageView.image = UIImage(named: viewModel.mainImageURL)
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorAvatarImageView.image = UIImage(named: viewModel.author.avatarImageURL)
        authorNameLabel.text = viewModel.author.userName
    }
}
