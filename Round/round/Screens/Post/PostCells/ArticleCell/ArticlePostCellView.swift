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
    
    var article = Text(.article)
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? ArticlePostCellViewModel else {print("ArticlePostCellView viewModel type error"); return}
        article.text = model.text
        setupDesign()
    }
    
    func setupDesign() {
        backgroundColor = .white
        addSubview(article)
        article.easy.layout(Leading(20),Trailing(20),Top(40),Bottom(40))
        article.numberOfLines = 0
        layoutSubviews()
    }
}
