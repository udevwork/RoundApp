//
//  IconLabelView.swift
//  round
//
//  Created by Denis Kotelnikov on 30.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class IconLabelView: UIView {
    
    let icon: UIImageView = {
        let i = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 14, height: 14)))
        i.contentMode = .scaleAspectFit
        i.tintColor = Colors.lightlabel.uicolor()
        return i
    }()
    
    let label: Text = Text(.light, Colors.lightlabel.uicolor())
    
    init(icon: Icons, text: String) {
        self.icon.image = icon.image(weight: .thin)
        self.label.text = text
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(icon)
        addSubview(label)
        label.sizeToFit()
        icon.easy.layout(Leading(), CenterY(), Size(11))
        label.easy.layout(Leading(3).to(icon), CenterY())
        self.easy.layout(Height(14),Width(17+label.frame.width))
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
