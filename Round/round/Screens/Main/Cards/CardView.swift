//
//  CardView.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CardView: UIView {
    
    var viewModel : CardViewModel? = nil
    var onCardPress : ((CardView, CardViewModel)->())? = nil
    var backgroundImageView : UIImageView = UIImageView(image: UIImage(named: "ImagePlaceholder"))
    fileprivate var backgroundImageViewMask : UIView = UIView()
    fileprivate var actionButton : UIButton = UIButton()
    var titleLabel : Text = Text(.title,  .white)
    var descriptionLabel : Text = Text(.article, .white)
    var authorAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var authorNameLabel : Text = Text(.article, .white)
    var gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.cardGradient.cgColor, UIColor.clear.cgColor], type: .axial)
    fileprivate var whiteFade : UIView = UIView()
    var transparent : CGFloat { get{return 0} set{
        if newValue > 1 {return}
        whiteFade.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1 - newValue)
        }}
    
    init(viewModel : CardViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setupData(viewModel)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupDesign(){
        gradient.frame = bounds
        gradient.cornerRadius = 13
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        layer.addSublayer(gradient)
        [authorAvatar, titleLabel, descriptionLabel, authorNameLabel,whiteFade,actionButton].forEach {
            addSubview($0)
        }
        whiteFade.backgroundColor = .white
        whiteFade.layer.cornerRadius = 13
        layer.cornerRadius = 13
        
        whiteFade.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        
        backgroundImageViewMask.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageViewMask.layer.cornerRadius = 13
        backgroundImageViewMask.layer.masksToBounds = true
        backgroundImageView.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageView.contentMode = .scaleAspectFill
        
        let attributedString = NSMutableAttributedString(string: descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.numberOfLines = 3
        descriptionLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        descriptionLabel.sizeToFit()
        
        titleLabel.numberOfLines = 1
        titleLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(5).to(descriptionLabel)
        )
        titleLabel.sizeToFit()
        
        authorAvatar.easy.layout(
            Leading(20),Top(20),Height(40),Width(40)
        )
        
        authorNameLabel.easy.layout(
            Leading(20).to(authorAvatar),
            Trailing(20),
            CenterY().to(authorAvatar),
            Height(40)
        )
        
        actionButton.easy.layout(
            Leading(),
            Trailing(),
            Top(),
            Bottom()
        )

        // TODO: create shadow
        //        layer.shadowRadius = 8
        //        layer.shadowOpacity = 0.3
        //        layer.shadowOffset = .zero
        layer.masksToBounds = false
        clipsToBounds = false
        
        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        layoutSubviews()
    }
    
    func setupData(_ viewModel : CardViewModel){
        self.viewModel = viewModel
        //  backgroundImageView.image = UIImage(named: viewModel.mainImageURL)
        backgroundImageView.setImage(url: viewModel.mainImageURL, placeholder: "ImagePlaceholder")
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorAvatar.setImage(viewModel.author.avatarImageURL)
        authorNameLabel.text = viewModel.author.userName
        layoutSubviews()
        
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        if viewModel == nil {return}
        onCardPress?(self,viewModel!)
    }
    
}
