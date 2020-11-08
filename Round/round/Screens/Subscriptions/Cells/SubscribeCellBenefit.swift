//
//  SubscribeCellBenefit.swift
//  round
//
//  Created by Denis Kotelnikov on 07.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SubscribeCellBenefit: UITableViewCell {
    
    private let title: Text = Text(.system, .label)
    private let icon = UIImageView(image: Icons.checkmark.image())
    
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
        addSubview(icon)
        icon.easy.layout(Leading(20), CenterY(), Size(20))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .systemIndigo
        title.easy.layout(Leading(10).to(icon), Trailing(20), Top(5), Bottom(5))
        title.numberOfLines = 0
        selectionStyle = .none
    }
    
    public func setup(data: SubscriptionsCellTextModel){
        self.title.text = data.text
    }
    
}
