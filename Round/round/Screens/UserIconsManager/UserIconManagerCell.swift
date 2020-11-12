//
//  UserIconManagerCell.swift
//  round
//
//  Created by Denis Kotelnikov on 12.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class UserIconManagerCell: UITableViewCell {
    private var content: UIView = UIView()
    private var titleLable: Text = Text(.article, .label)
    private var describtionLable: Text = Text(.regular, .systemGray)
    private var icon: UIImageView = UIImageView()
    
    public var onPessUnpack: ((DownloadViewModel.Model)->())? = nil
    
    public var model: DownloadViewModel.Model? = nil
    
    private let unpackButton: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
        .setStyle(.icon)
        .setIconColor(.label)
        .setIcon(.save)
        .setColor(.clear)
        .build()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign() {
        backgroundColor = .clear
        contentView.addSubview(content)
        content.layer.cornerRadius = 15
        content.backgroundColor = .systemGray6
        content.easy.layout(Leading(20),Trailing(20),Top(4),Bottom(4))
        content.addSubview(icon)
        icon.easy.layout(Size(70),CenterY(),Leading(20))
        icon.contentMode = .scaleAspectFill
        icon.tintColor = .systemGray
        icon.layer.masksToBounds = true
        icon.layer.borderWidth = 4
        icon.layer.borderColor = UIColor.systemGray5.cgColor
        content.addSubview(titleLable)
        content.addSubview(describtionLable)
        content.addSubview(unpackButton)

        titleLable.easy.layout(Leading(20).to(icon), CenterY(-12), Trailing(20).to(unpackButton))
        titleLable.numberOfLines = 1
        titleLable.lineBreakMode = .byTruncatingTail
        
        describtionLable.easy.layout(Leading(20).to(icon), Top(5).to(titleLable), Trailing(20).to(unpackButton))
        describtionLable.numberOfLines = 2
        describtionLable.lineBreakMode = .byTruncatingTail
        
        unpackButton.easy.layout(CenterY(), Trailing(20), Size(60))
        unpackButton.setTarget { [weak self] in
            if let m = self?.model {
                self?.onPessUnpack?(m)
            }
        }
        selectionStyle = .none
    }
    
    public func setup(model: DownloadViewModel.Model){
        icon.image = model.downloadbleImage
        self.titleLable.text = model.downloadbleName
        self.describtionLable.text = model.downloadbleDescription
        self.model = model
    }
    
}
