//
//  SubscribeCellInfo.swift
//  round
//
//  Created by Denis Kotelnikov on 07.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SubscribeCellInfo: UITableViewCell {
    
    private var title: Text = Text(.small, .label)
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign() {
        backgroundColor = .clear
        addSubview(title)
        title.easy.layout(Leading(20), Trailing(20), Top(10), Bottom(10))
        title.numberOfLines = 0
        selectionStyle = .none
    }
    
    public func setup(data: SubscriptionsCellTextModel){
        self.title.text = data.text
    }
    
}
