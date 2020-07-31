//
//  UserAvatarNameDate.swift
//  round
//
//  Created by Denis Kotelnikov on 30.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import EasyPeasy

class UserAvatarNameDate: UIView {
    private let avatar: UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    private let nameLabel: Text = Text(.regular, Colors.label.uicolor())
    private var dateView: IconLabelView? = nil
    private let stack: UIStackView = UIStackView()
    
    init(_ avatarURL: URL?,_ userName: String?, _ data: Timestamp?) {
        avatar.setImage(avatarURL)
        nameLabel.text = userName
        super.init(frame: .zero)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(avatar)
        addSubview(stack)
        avatar.easy.layout(Width(40),Height(40))
        stack.alignment = .leading
        stack.distribution = .fill
        stack.axis = .vertical
        avatar.easy.layout(Leading(),CenterY())
        stack.easy.layout(Leading(5).to(avatar),CenterY(),Trailing())
        self.easy.layout(Height(40))
    }
    
    public func setAvatar(_ url: URL?){
        avatar.setImage(url)
    }
    
    private var userArraanged: Bool = false
    public func setUser(_ name: String){
        nameLabel.text = name
        if !userArraanged {
            stack.addArrangedSubview(nameLabel)
            userArraanged = true
        }
        
    }
    
    private var dateArraanged: Bool = false
    public func setCreation(_ date: String) {
        if !dateArraanged {
            dateView = IconLabelView(icon: .clock, text: date)
            if let view = dateView {
                stack.addArrangedSubview(view)
                dateArraanged = true
            }
        } else {
            if let view = dateView {
                view.label.text = date
            }
        }
    }
}
