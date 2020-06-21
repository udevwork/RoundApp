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
    
    var article = Text(.article, .secondaryLabel, .zero)
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? ArticlePostCellViewModel else {print("ArticlePostCellView viewModel type error"); return}

        let mainText = model.text ?? ""
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 8
        paragraph.lineSpacing = 2
    
        
        let atributedString = NSMutableAttributedString(string: mainText,
        attributes: [NSAttributedString.Key.font : article.font!,
                     NSAttributedString.Key.paragraphStyle : paragraph])

     
        
        article.attributedText = atributedString
        setupDesign()
    }
    
    func setupDesign() {
        backgroundColor = .systemGray6
        addSubview(article)
        article.easy.layout(Leading(20),Trailing(20),Top(40),Bottom(40))
        article.numberOfLines = 0
        layoutSubviews()
    }
    func setPadding(padding: UIEdgeInsets) {
        article.easy.layout(Leading(padding.left),Trailing(padding.right),Top(padding.top),Bottom(padding.bottom))
        layoutSubviews()
    }
}
