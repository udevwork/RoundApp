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
    let loader: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    fileprivate var btnText : Text = Text(.article)
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        addTarget(self, action: #selector(buttonDown), for: .touchDown)
        addTarget(self, action: #selector(buttonRelese), for: .touchUpInside)
        addTarget(self, action: #selector(buttonRelese), for: .touchUpOutside)

    }
    
    fileprivate func setStyle(style : Style){
        
        switch style {
        case .iconText:
            addSubview(icon)
            addSubview(btnText)
            btnText.easy.layout(Top(10),Bottom(10),Trailing(20))
            icon.easy.layout(CenterY(),Width(20),Height(20),Leading(20),Trailing(20).to(btnText))
        case .textIcon:
            addSubview(btnText)
            addSubview(icon)
        case .text:
            addSubview(btnText)
            btnText.easy.layout(Top(10),Bottom(10),Leading(20),Trailing(20))
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
    
    func setIcon(_ icon : UIImage) {
        self.icon.image = icon
        self.icon.contentMode = .scaleAspectFit
    }
    
    func setIcon(_ icon : Icons) {
        self.icon.image = icon.image()
        self.icon.contentMode = .scaleAspectFit
    }
    
    private var saveTintColor: UIColor? = nil
    func setIconColor(_ color : UIColor) {
        self.icon.tintColor = color
        saveTintColor = color
    }
    
    private var pressBlocked: Bool = false
    fileprivate var pressBlockingTime: TimeInterval = 0
    
    @objc func buttonClicked(sender:UIButton)
    {
        if pressBlockingTime != 0 {
            if pressBlocked == false {
                onPress?()
                pressBlocked = true
                DispatchQueue.main.asyncAfter(deadline: .now() + pressBlockingTime) { [weak self] in
                    self?.pressBlocked = false
                }
            }
        } else {
            onPress?()
        }
    }
    
    @objc func buttonRelese(sender:UIButton)
    {
        if saveTintColor != nil{
            icon.tintColor = saveTintColor
        } else {
            icon.tintColor = .label
        }
    }
    @objc func buttonDown(sender:UIButton)
    {
        icon.tintColor = .systemIndigo
    }
    
    public func showLoader(_ show: Bool){
        if style == .some(.icon) || style == .some(.iconText) {
            if show {
                if loader.superview == nil {
                    addSubview(loader)
                    loader.frame = icon.frame
                    icon.isHidden = true
                    loader.startAnimating()
                }
            } else {
                loader.removeFromSuperview()
                loader.stopAnimating()
                icon.isHidden = false
            }
        } else {
            debugPrint("loader can be only if  style == .icon or .iconText")
        }
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
        return self
    }
    
    func setTextColor(_ color : UIColor) -> ButtonBuilder {
        button.btnText.textColor = color
        return self
    }
    
    func setIcon(_ imageName : String) -> ButtonBuilder {
        button.icon.isUserInteractionEnabled = false
        button.icon.image = UIImage(named: imageName)
        return self
    }
    
    func setIcon(_ icon : UIImage) -> ButtonBuilder {
        button.icon.image = icon
        button.icon.contentMode = .scaleAspectFit
        return self
    }
    
    func setIcon(_ icon : Icons) -> ButtonBuilder {
        button.icon.image = icon.image()
        button.icon.contentMode = .scaleAspectFit
        return self
    }
    
    func setIconColor(_ color : UIColor) -> ButtonBuilder {
        button.setIconColor(color)
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
    
    func setPressBlockingTimer(_ time : TimeInterval) -> ButtonBuilder {
        button.pressBlockingTime = time
        return self
    }
    
    func setTextCentered() -> ButtonBuilder {
        button.btnText.easy.clear()
        button.btnText.easy.layout(Edges())
        button.btnText.textAlignment = .center
        return self
    }
    
    func build() -> Button {
        if button.style == nil { debugPrint("Button builder: ", "You need to assign a style for button!") }
        if button.style == Button.Style.text {
            if button.btnText.text == "" {
                debugPrint("Button builder: ", "It looks like you forgot to add text for the button")
            }
        }
        if button.style == Button.Style.icon {
            if button.icon.image == nil {
                debugPrint("Button builder: ", "it looks like you forgot to add an icon for the button")
            }
        }
        if button.backColor == nil {
            button.backgroundColor = .systemIndigo
        }
        return button
    }
}
