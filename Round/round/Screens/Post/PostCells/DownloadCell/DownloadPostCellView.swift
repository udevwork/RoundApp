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
    
    public var id: String = UUID().uuidString
    public var postType: PostCellType = .Download
    public var onDownloadPress: ((String)->())? = nil
    
    private let content: UIView = UIView()
    
    public var link: String? = nil
    private var title = Text(.article, .systemGray3, .zero)
    private let downloadButton: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        .setStyle(.iconText)
        .setColor(.black)
        .setText(localized(.download))
        .setTextColor(.white)
        .setIcon(.download)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .setCornerRadius(8)
        .setShadow(ShadowPresets.regular)
        .build()
    
   public func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? DownloadPostCellViewModel else {print("TitlePostCellView viewModel type error"); return}
        title.text = model.fileSize
        link = model.downloadLink
        setupDesign()
    }
        
    func setupDesign() {
        backgroundColor = .clear
        contentView.addSubview(content)
        content.easy.layout(Edges(20))
        content.backgroundColor = .systemGray5
        content.layer.cornerRadius = 15
        content.addSubview(title)
        content.addSubview(downloadButton)
        downloadButton.easy.layout(Trailing(20), CenterY(), Top(20), Bottom(20))
        title.easy.layout(Leading(20), CenterY())
        title.numberOfLines = 1
        title.sizeToFit()
        layoutSubviews()
        downloadButton.setTarget { [weak self] in
            self?.onDownloadPress?(self?.link ?? "")
        }
    }
    
    func setPadding(padding: UIEdgeInsets) {
       // title.easy.layout(Leading(padding.left),Trailing(padding.right),Top(padding.top),Bottom(padding.bottom))
       // layoutSubviews()
    }
}
