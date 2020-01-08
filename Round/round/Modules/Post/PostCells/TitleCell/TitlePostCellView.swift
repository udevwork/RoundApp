//
//  TitlePostCellView.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class TitlePostCellView: UITableViewCell, BasePostCellProtocol {
    var id: String = UUID().uuidString
    var postType: PostCellType = .Title
    
    var title = Text(frame: .zero, fontName: .Bold, size: 21)
    
    func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? TitlePostCellViewModel else {print("TitlePostCellView viewModel type error"); return}
        title.text = model.text
        setupDesign()
    }
    
    func setupDesign() {
        addSubview(title)
        title.easy.layout(Leading(20),Trailing(20),Top(10),Bottom(10))
        title.numberOfLines = 0
        title.sizeToFit()
        
        layoutSubviews()
    }
}


