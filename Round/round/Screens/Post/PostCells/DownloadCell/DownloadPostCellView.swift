//
//  DownloadPostCellView.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class DownloadPostCellView: UITableViewCell, BasePostCellProtocol {
    
    var id: String = UUID().uuidString
    var postType: PostCellType = .Title
    
    var title = Text(.title, .label, .zero)
    
   public func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? TitlePostCellViewModel else {print("TitlePostCellView viewModel type error"); return}
        title.text = model.text
        setupDesign()
    }
    
    func setupDesign() {
        backgroundColor = .systemGray6
        addSubview(title)
        title.easy.layout(Leading(20),Trailing(20),Top(40),Bottom(40))
        title.numberOfLines = 0
        title.sizeToFit()
        layoutSubviews()
    }
    
    func setPadding(padding: UIEdgeInsets) {
        title.easy.layout(Leading(padding.left),Trailing(padding.right),Top(padding.top),Bottom(padding.bottom))
        layoutSubviews()
    }
}
