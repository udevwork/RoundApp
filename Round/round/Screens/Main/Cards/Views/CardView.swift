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
    var backgroundImageView : UIImageView = UIImageView(image: Images.imagePlaceholder.uiimage())
    var backgroundImageViewMask : UIView = UIView()
    var actionButton : UIButton = UIButton()
    var titleLabel : Text = Text(.title,  .white)
    var descriptionLabel : Text = Text(.article, .white)
    var authorAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var authorNameLabel : Text = Text(.article, .white)
    var gradient : CAGradientLayer = CAGradientLayer(start: .bottomCenter, end: .topCenter, colors: [UIColor.black.cgColor, UIColor.clear.cgColor], type: .axial)
    
    let viewCountIcon: UIImageView = UIImageView(image: Icons.eye.image())
    let viewCountLabel: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42))
    let creationDateLabel: Text = Text(.regular, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42))
    
    init(viewModel : CardViewModel?, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setupDesign()
        setupData(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDesign(){
        gradient.cornerRadius = 13
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        backgroundImageViewMask.layer.addSublayer(gradient)
        
        [titleLabel,descriptionLabel,actionButton,viewCountIcon,viewCountLabel,creationDateLabel].forEach {
            addSubview($0)
        }
        
        layer.cornerRadius = 13
        clipsToBounds = false
        
        backgroundImageViewMask.easy.layout(
            Leading(),Trailing(),Top(),Bottom()
        )
        backgroundImageViewMask.layer.cornerRadius = 13
        backgroundImageViewMask.layer.masksToBounds = true
        backgroundImageView.easy.layout(Edges())
        backgroundImageView.contentMode = .scaleAspectFill
        
        let attributedString = NSMutableAttributedString(string: descriptionLabel.text ?? "")
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
        
        addSubview(authorAvatar)
        addSubview(authorNameLabel)
        
        authorAvatar.easy.layout(
            Leading(20),Top(20),Height(40),Width(40)
        )
        
        authorNameLabel.easy.layout(
            Leading(20).to(authorAvatar),
            Trailing(20),
            CenterY().to(authorAvatar),
            Height(40)
        )
        
        viewCountIcon.contentMode = .scaleAspectFit
        viewCountIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.42)
        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Bottom(9).to(titleLabel))
        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY(1).to(viewCountIcon))
        
        creationDateLabel.easy.layout(Leading(3).to(viewCountLabel),Trailing(20),CenterY(1).to(viewCountIcon))
        actionButton.easy.layout(Edges())

        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width+3, height: bounds.height+3))
    }
    
    func setupData(_ viewModel : CardViewModel?){
        self.viewModel = viewModel
        guard let model = self.viewModel else {
            return
        }
        backgroundImageView.setImage(imageURL: URL(string: model.mainImageURL), placeholder: Images.imagePlaceholder.uiimage())
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        

            if let strongString = viewModel?.author?.photoUrl, let url = URL(string: strongString) {
                authorAvatar.setImage(url)
            } else {
                authorAvatar.setImage(Images.avatarPlaceholder.uiimage())
            }
            authorNameLabel.text = viewModel?.author?.userName

        
        viewCountLabel.text = "\(model.viewsCount)"
        if let timeResult = model.creationDate?.dateValue().timeIntervalSince1970 {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            creationDateLabel.text = localDate
        }
        layoutSubviews()
        
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        if viewModel == nil {return}
        onCardPress?(self,viewModel!)
    }
    
}
