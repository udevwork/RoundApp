//
//  Button.swift
//  round
//
//  Created by Denis Kotelnikov on 21.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class Button: UIButton {
    
    enum Style {
        case iconText
        case textIcon
        case text
        case icon
    }
    
    fileprivate var style : Style? = nil
    fileprivate var backColor : UIColor? = nil
    var onPress : (()->())? = nil
    
    
     var icon : UIImageView = UIImageView()
    fileprivate var btnText : Text = Text(.article)
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    fileprivate func setStyle(style : Style){
        
        switch style {
        case .iconText:
            addSubview(icon)
            addSubview(btnText)
        case .textIcon:
            addSubview(btnText)
            addSubview(icon)
        case .text:
            addSubview(btnText)
        case .icon:
            addSubview(icon)
            icon.easy.layout(CenterX(),CenterY(),Width(20),Height(20))
        }
        
    }
    
    func setTarget(_ target : @escaping ()->()) {
        onPress = target
    }
    
    func setText(_ text : String) {
        btnText.text = text
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        onPress?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ButtonBuilder {
    fileprivate var button : Button = Button()
    
    func setFrame(_ frame : CGRect) -> ButtonBuilder {
        button.frame = frame
        return self
    }
    
    func setStyle(_ style : Button.Style) -> ButtonBuilder {
        button.style = style
        button.setStyle(style: style)
        return self
    }
    
    func setText(_ text : String) -> ButtonBuilder {
        button.btnText.text = text
        button.btnText.easy.layout(Top(10),Bottom(10),Leading(20),Trailing(20))

        return self
    }
    
    func setTextColor(_ color : UIColor) -> ButtonBuilder {
        button.btnText.textColor = color
        return self
    }
    
    func setIcon(_ imageName : String) -> ButtonBuilder {
        button.icon.isUserInteractionEnabled = true
        button.icon.image = UIImage(named: imageName)
        return self
    }
    
    func setIcon(_ icon : UIImage) -> ButtonBuilder {
        button.icon.image = icon
        button.icon.contentMode = .scaleAspectFit
        return self
    }
    
    func setIconColor(_ color : UIColor) -> ButtonBuilder {
        button.icon.tintColor = color
        return self
    }
    
    func setColor(_ color : UIColor) -> ButtonBuilder {
        button.backColor = color
        button.backgroundColor = color
        return self
    }
    
    func setIconSize(_ size : CGSize) -> ButtonBuilder {
        button.icon.easy.layout(Width(size.width),Height(size.height))
        return self
    }
    
    func setShadow(_ shadowPreset : ShadowPresets) -> ButtonBuilder {
        button.setupShadow(preset: shadowPreset)
        return self
    }
    
    func setCornerRadius(_ corners: CACornerMask ,_ radius: CGFloat) -> ButtonBuilder {
        button.roundCorners(corners: corners, radius: radius)
        return self
    }
    
    func setCornerRadius(_ radius: CGFloat) -> ButtonBuilder {
        button.roundCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: radius)
        return self
    }
    
    func setMaxHorCornerRadius() -> ButtonBuilder {
        button.layer.cornerRadius = button.frame.width / 2
        return self
    }
    
    func setMaxVertCornerRadius() -> ButtonBuilder {
        button.layer.cornerRadius = button.frame.height / 2
        return self
    }
    
    func setTarget(_ target : @escaping ()->()) -> ButtonBuilder {
        button.setTarget(target)
        return self
    }
    
    func build() -> Button {
        if button.style == nil { Debug.log("Button builder: ", "You need to assign a style for button!") }
        if button.style == Button.Style.text {
            if button.btnText.text == "" {
                Debug.log("Button builder: ", "It looks like you forgot to add text for the button")
            }
        }
        if button.style == Button.Style.icon {
            if button.icon.image == nil {
                Debug.log("Button builder: ", "it looks like you forgot to add an icon for the button")
            }
        }
        if button.backColor == nil {
            button.backgroundColor = .systemIndigo
        }
        return button
    }
}
