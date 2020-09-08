//
//  IconLableBluredView.swift
//  round
//
//  Created by Denis Kotelnikov on 31.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class IconLableBluredView: UIView {
    
    private let height: CGFloat = 30
    private let iconSize: CGFloat = 18
    private let offset: CGFloat = 10
    private var onPress: (()->())? = nil
    
    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    let icon: UIImageView = {
        let i = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 18, height: 18)))
        i.contentMode = .scaleAspectFit
        i.tintColor = .white
        return i
    }()
    
    let label: Text = Text(.system, .white)
    
    init(icon: Icons, text: String, _ onPress: (()->())? = nil) {
        self.icon.image = icon.image(weight: .regular)
        self.label.text = text
        super.init(frame: .zero)
        self.onPress = onPress
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addTarget( _ onPress: @escaping (()->())){
        self.onPress = onPress
    }
    
    private func setupView() {
        addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(icon)
        blurredEffectView.contentView.addSubview(label)
        blurredEffectView.layer.cornerRadius = height/2
        blurredEffectView.layer.masksToBounds = true
        blurredEffectView.easy.layout(Edges())
        label.sizeToFit()
        icon.easy.layout(Leading(offset), CenterY(), Size(iconSize))
        label.easy.layout(Leading(offset).to(icon), CenterY())
        let w = offset*3 + iconSize + label.frame.width
        self.easy.layout(Height(height),Width(w))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPress)))
    }
        
    @objc func buttonPress(){
        onPress?()
    }
    
}
