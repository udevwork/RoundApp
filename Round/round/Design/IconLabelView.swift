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
    
    private let iconSize: CGSize = CGSize(width: 19, height: 19)
    private let contentInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 20)
    
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private var iconView: UIImageView?
    private var labelView: Text?
    
    init(icon: Icons? = nil, text: String? = nil) {
        super.init(frame: .zero)
        setupView()
        if let icon = icon {
            setIcon(icon)
        }
        if let text = text {
            setText(text)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(blurredEffectView)
        blurredEffectView.layer.masksToBounds = true
    }
    
    public func setIcon(_ icon: Icons){
        if iconView != nil {
            iconView!.image = icon.image(weight: .thin)
            setupFrame()
            return
        }
        iconView = UIImageView(frame: CGRect(origin: .zero, size: iconSize))
        guard let iconView = iconView else { return }
        blurredEffectView.contentView.addSubview(iconView)
        
        iconView.image = icon.image(weight: .thin)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
            
        blurredEffectView.contentView.addSubview(iconView)
                
        iconView.easy.layout(Size(iconSize), Leading(contentInset.left), CenterY())
        setupFrame()
        
    }
    
    public func setText(_ text: String){
        if labelView != nil {
            labelView!.text = text
            labelView!.sizeToFit()
            setupFrame()
            return
        }
        self.labelView = Text(.system, .white)
        guard let labelView = labelView else { return }
        labelView.text = text
        blurredEffectView.contentView.addSubview(labelView)
        labelView.sizeToFit()
        labelView.easy.layout(
            Leading(5).to(iconView!).when{ self.iconView != nil },
            Leading(5).when{ self.iconView == nil },
            CenterY())
        setupFrame()
    }
    
    private func setupFrame(){
        let width: CGFloat = iconSize.width + contentInset.left + contentInset.right + (labelView?.frame.width ?? 0)
        let height: CGFloat = iconSize.height + contentInset.bottom + contentInset.top
        let size = CGSize(width: width, height: height)

        frame =  CGRect(origin: .zero, size: size)
        blurredEffectView.frame = frame
        blurredEffectView.layer.cornerRadius = frame.height/2

        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
