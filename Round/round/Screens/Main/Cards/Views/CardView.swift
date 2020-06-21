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
    var titleLabel : Text = Text(.title,  .label)
    var descriptionLabel : Text = Text(.regular, .secondaryLabel)
    var authorAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var authorNameLabel : Text = Text(.article, .white)

    let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    let viewCountIcon: UIImageView = UIImageView(image: Icons.eye.image())
    let viewCountLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1))
    let creationDateLabel: Text = Text(.regular, #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1))
    
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
        blurredEffectView.layer.cornerRadius = 13
        blurredEffectView.layer.masksToBounds = true
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        backgroundImageViewMask.addSubview(blurredEffectView)
        
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
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.easy.layout(
            Leading(20),Trailing(20),Bottom(20)
        )
        descriptionLabel.sizeToFit()
        
        titleLabel.numberOfLines = 2
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
        
        blurredEffectView.easy.layout(Leading(10), Trailing(10), Bottom(10), Top(-8).to(titleLabel,.top))
        
        viewCountIcon.contentMode = .scaleAspectFit
        viewCountIcon.tintColor = #colorLiteral(red: 0.7657949328, green: 0.761243999, blue: 0.7692939639, alpha: 1)
        viewCountIcon.easy.layout(Width(17),Height(17),Leading(20),Bottom(11).to(titleLabel))
        viewCountLabel.easy.layout(Leading(5).to(viewCountIcon),CenterY().to(viewCountIcon))
        
        creationDateLabel.easy.layout(Leading(3).to(viewCountLabel),Trailing(20),CenterY(0).to(viewCountIcon))
        actionButton.easy.layout(Edges())

        actionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layoutSubviews()
    }
    
    func setupData(_ viewModel : CardViewModel?){
        self.viewModel = viewModel
        guard let model = self.viewModel else {
            return
        }
        backgroundImageView.setImage(imageURL: URL(string: model.mainImageURL), placeholder: Images.imagePlaceholder.uiimage())
        
        titleLabel.text = model.title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        let attributedString = NSMutableAttributedString(string:  viewModel?.description ?? "", attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        descriptionLabel.attributedText = attributedString
        
        

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
