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
    
    var article = Text(.article, .label, .zero)
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? ArticlePostCellViewModel else {print("ArticlePostCellView viewModel type error"); return}
        let firstChar = model.text?.first
        let lastText = model.text?.suffix(from: model.text!.index(after: model.text!.startIndex))
        let atributedString = NSMutableAttributedString()
        let firstCharFont = FontNames.PlayBold.uiFont(19)
        
        let paragraph = NSAttributedString(string: "   ")
        let firstAtributedText = NSAttributedString(string: String.init(firstChar!), attributes: [NSAttributedString.Key.font : firstCharFont])
        let lastAtributedText = NSAttributedString(string: String.init(lastText!), attributes: [NSAttributedString.Key.font : article.font!])
        
        atributedString.append(paragraph)
        atributedString.append(firstAtributedText)
        atributedString.append(lastAtributedText)

        
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
