//
//  PostBlockSelectorTableViewHeaderView.swift
//  round
//
//  Created by Denis Kotelnikov on 10.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostBlockSelectorTableViewHeaderView: UIView {
    
    private lazy var header: UIVisualEffectView = {
        let blure : UIBlurEffect = UIBlurEffect(style: .prominent)
        let blureview: UIVisualEffectView = UIVisualEffectView(effect: blure)
        return blureview
    }()
    lazy var headerTitle: Text = Text(.regular, .label)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(header)
        addSubview(headerTitle)
        header.easy.layout(Edges())
        headerTitle.easy.layout(Leading(30),Trailing(),Top(),Bottom())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
