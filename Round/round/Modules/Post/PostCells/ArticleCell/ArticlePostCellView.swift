//
//  ArticlePostCellView.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//


import UIKit
import EasyPeasy

class ArticlePostCellView: UITableViewCell, BasePostCellProtocol {
    var id: String = UUID().uuidString
    var postType: PostCellType = .Article
    
    var article = Text(frame: .zero, fontName: .Regular, size: 16)
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? ArticlePostCellViewModel else {print("ArticlePostCellView viewModel type error"); return}
        article.text = model.text
        setupDesign()
    }
    
    func setupDesign() {
        addSubview(article)
        article.easy.layout(Leading(20),Trailing(20),Top(10),Bottom(10))
        article.numberOfLines = 0
        article.sizeToFit()
        
        layoutSubviews()
    }
}
