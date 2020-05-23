//
//  textKeybordEditor.swift
//  round
//
//  Created by Denis Kotelnikov on 09.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class textKeybordEditor: UIView {
        
    private lazy var keybordToolKit: UIVisualEffectView = {
        let blure : UIBlurEffect = UIBlurEffect(style: .prominent)
        let blureview: UIVisualEffectView = UIVisualEffectView(effect: blure)
        return blureview
    }()
    private lazy var keybordToolKitStask: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.backgroundColor = .clear
        return stack
    }()
    
    let textLeftAligment : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.alignleft)
        .build()
    let textCenterAligment : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.aligncenter)
        .build()
    let textRightAligment : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.alignright)
        .build()
    let textBold : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.bold)
        .build()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(keybordToolKit)
        addSubview(keybordToolKitStask)
        
        keybordToolKit.easy.layout(Edges())
        keybordToolKitStask.easy.layout(Edges())
        
        keybordToolKitStask.addArrangedSubview(textLeftAligment)
        keybordToolKitStask.addArrangedSubview(textCenterAligment)
        keybordToolKitStask.addArrangedSubview(textRightAligment)
        keybordToolKitStask.addArrangedSubview(textBold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
