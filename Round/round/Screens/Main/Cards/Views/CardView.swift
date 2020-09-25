//
//  CardView.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.

 /*
// MARK: TO SETUP SHADOW USE:
 backgroundImageViewMask.setupShadow(preset: .Post)
 */


import Foundation
import UIKit
import EasyPeasy

class CardView: UIView {
    
    var viewModel : CardViewModel? = nil
    var onCardPress : ((CardView, CardViewModel)->())? = nil
    var backgroundImageView : UIImageView = UIImageView(image: Images.imagePlaceholder.uiimage())
    var backgroundImageViewMask : UIView = UIView()
    var actionButton : UIButton = UIButton()
   
    let viewsCounterView: IconLabelView = IconLabelView(icon: Icons.eye, text: "101")

    let bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView()
    
    init(viewModel : CardViewModel?, frame: CGRect) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setupData(viewModel)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDesign() {
        layer.cornerRadius = 13
        clipsToBounds = false
        backgroundImageView.layer.cornerRadius = 50
        backgroundImageView.layer.masksToBounds = true
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        backgroundImageViewMask.addSubview(bottomTextBlockView)
        [actionButton, viewsCounterView].forEach { addSubview($0) }
        backgroundImageViewMask.easy.layout(Leading(), Trailing(), Top(), Bottom())
        backgroundImageViewMask.layer.masksToBounds = false
        backgroundImageView.easy.layout(Edges())
        backgroundImageView.contentMode = .scaleAspectFill
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonClicked)))
    }
    
    func setupData(_ viewModel : CardViewModel?){
        self.viewModel = viewModel
        
        guard let model = self.viewModel else { return }
        backgroundImageView.setImage(imageURL: URL(string: model.mainImageURL), placeholder: Images.imagePlaceholder.uiimage())
        bottomTextBlockView.set(model.title, model.description)
        
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        if viewModel == nil {return}
        onCardPress?(self,viewModel!)
    }
    
}
