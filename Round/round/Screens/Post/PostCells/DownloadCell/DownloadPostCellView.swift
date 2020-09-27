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
    public var link: String? = nil
    public var title = Text(.article, .systemGray3, .zero)
    public let downloadButton: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        .setStyle(.iconText)
        .setColor(.black)
        .setText("Download")
        .setTextColor(.white)
        .setIcon(.download)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .setCornerRadius(8)
        .setShadow(ShadowPresets.Button)
        .build()
    
   public func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? DownloadPostCellViewModel else {print("TitlePostCellView viewModel type error"); return}
        title.text = model.fileSize
        link = model.downloadLink
        setupDesign()
    }
        
    func setupDesign() {
        backgroundColor = .systemGray6
        contentView.addSubview(title)
        contentView.addSubview(downloadButton)
        downloadButton.easy.layout(Trailing(20), CenterY().to(title))
        title.easy.layout(Trailing(20).to(downloadButton, .leading),Top(40),Bottom(40), Height(80))
        title.numberOfLines = 1
        title.sizeToFit()
        layoutSubviews()
        downloadButton.setTarget { [weak self] in
            print("download: ", self?.link as Any)
            self?.onDownloadPress?(self?.link ?? "")
        }
    }
    
    func setPadding(padding: UIEdgeInsets) {
       // title.easy.layout(Leading(padding.left),Trailing(padding.right),Top(padding.top),Bottom(padding.bottom))
       // layoutSubviews()
    }
}
