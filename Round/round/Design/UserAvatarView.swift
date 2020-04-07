//
//  UserAvatarUI.swift
//  round
//
//  Created by Denis Kotelnikov on 17.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import UIKit
import EasyPeasy

class UserAvatarView: UIView {
    fileprivate var authorAvatarImageViewMask = UIView()
    //fileprivate var authorAvatarShadow = UIView()
    fileprivate var authorAvatarImageView = UIImageView()
    var image: UIImage? {
        return authorAvatarImageView.image
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(authorAvatarShadow)
        addSubview(authorAvatarImageViewMask)
        authorAvatarImageViewMask.addSubview(authorAvatarImageView)
        // authorAvatarImageView.contentMode = .scaleAspectFill
        [/*authorAvatarShadow,*/ authorAvatarImageViewMask, authorAvatarImageView].forEach({
            $0.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            $0.easy.layout(
                Leading(),Trailing(),Top(),Bottom()
            )
        })
        authorAvatarImageViewMask.layer.cornerRadius = frame.width/2
//        authorAvatarImageViewMask.layer.borderWidth = 2
 //       authorAvatarImageViewMask.layer.borderColor = UIColor.white.cgColor
        authorAvatarImageViewMask.layer.masksToBounds = true
//        authorAvatarShadow.backgroundColor = .white
//        authorAvatarShadow.layer.cornerRadius =  frame.width/2
//        authorAvatarShadow.setupShadow(preset: .NavigationBar)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ imageName : String){
        authorAvatarImageView.image = UIImage(named: imageName)
    }
    
    func setImage(_ image : UIImage){
        authorAvatarImageView.image = image
    }
    
    func setImage(_ image : URL?){
        guard let imgUrl = image else {
            return
        }
        authorAvatarImageView.setImage(imageURL: imgUrl, placeholder: "avatarPlaceholder")
    }
}
