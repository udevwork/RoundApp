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
    let avatar: UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let nameLabel: Text = Text(.regular, Colors.label.uicolor())
    var dateView: IconLabelView? = nil
    
    override var frame: CGRect {
        didSet {
            print("frame changed: ", frame);
        }
    }
    
    private let stack: UIStackView = UIStackView()
    
    init(_ avatarURL: URL?,_ userName: String?, _ data: Timestamp?) {
        avatar.setImage(avatarURL)
        nameLabel.text = userName
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 40)))
        setupView()
    }
    
    init(_ avatar: UserAvatarNameDate) {
        super.init(frame: avatar.frame)

        self.setAvatar(avatar.avatar.image)
        
        if let name = avatar.nameLabel.text {
            self.setUser(name)
        }
        
        if let date = avatar.dateView?.label.text {
            self.setCreation(date)
        }
        
        setupViewFromOtherView()
    }
    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 40)))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(avatar)
        addSubview(stack)
        stack.alignment = .leading
        stack.distribution = .fill
        stack.axis = .vertical
        avatar.easy.layout(Leading(),CenterY(),Width(40),Height(40))
        stack.easy.layout(Leading(20).to(avatar),CenterY(),Trailing())
        
    }
    
    private func setupViewFromOtherView(){
        setupView()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func setAvatar(_ url: URL?){
        avatar.setImage(url)
    }
    
    public func setAvatar(_ img: UIImage?){
        avatar.setImage(img)
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
