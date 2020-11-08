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
    public var onbuyPress: ((String)->())? = nil
    public var isPurchised: Bool = false
    
    private let content: UIView = UIView()
    
    public var link: String? = nil
    public var productID: String? = nil
    
    private var title = Text(.price, .label, .zero)
    private let downloadButton: Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        .setStyle(.iconText)
        .setColor(.black)
        .setTextColor(.white)
        .setIconColor(.white)
        .setIconSize(CGSize(width: 20, height: 20))
        .setCornerRadius(8)
        .setShadow(ShadowPresets.regular)
        .build()
    
    public func setup(viewModel: BasePostCellViewModelProtocol) {
        guard let model = viewModel as? DownloadPostCellViewModel else { print("TitlePostCellView viewModel type error"); return }
        if let id = model.productID {
            if SubscriptionsViewModel.userSubscibed == false {
                if ProductManager().get(productID: id) == nil {
              // if false {
                    IAPManager.shared.getPackPrice(ID: id) { product in
                        if let product = product {
                            self.title.text = product.localizedPrice
                            self.downloadButton.setText(localized(.buy))
                            self.downloadButton.setIcon(.cart)
                            self.downloadButton.isHidden = false
                        } else {
                            self.title.text = localized(.packnotavailable)
                            self.downloadButton.isHidden = true
                        }
                    }
                } else {
                    self.title.text = model.fileSize
                    self.downloadButton.setText(localized(.download))
                    self.downloadButton.setIcon(.download)
                    self.downloadButton.isHidden = false
                    isPurchised = true
                }
            } else {
                self.title.text = model.fileSize
                self.downloadButton.setText(localized(.download))
                self.downloadButton.setIcon(.download)
                self.downloadButton.isHidden = false
                isPurchised = true
            }
        } else {
            self.title.text = localized(.packnotavailable)
            self.downloadButton.isHidden = true
        }
        link = model.downloadLink
        productID = model.productID
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
            guard let self = self else {return}
            if self.isPurchised {
                self.onDownloadPress?(self.link ?? "")
            } else {
                self.onbuyPress?(self.productID ?? "")
            }
            self.downloadButton.showLoader(true)
        }
    }
    
    func setPadding(padding: UIEdgeInsets) {
        // title.easy.layout(Leading(padding.left),Trailing(padding.right),Top(padding.top),Bottom(padding.bottom))
        // layoutSubviews()
    }
}
