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
   
    let downloadsCounterView: IconLabelView = IconLabelView()

    let bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView()
    
    init() {
        super.init(frame: .zero)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDesign() {
        layer.borderWidth = 6
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.cornerRadius = 50
        clipsToBounds = false
        backgroundImageView.layer.cornerRadius = 50
        backgroundImageView.layer.masksToBounds = true
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        backgroundImageViewMask.addSubview(bottomTextBlockView)
        [actionButton, downloadsCounterView].forEach { addSubview($0) }
        downloadsCounterView.easy.layout(Top(35),Leading(35))
        backgroundImageViewMask.easy.layout(Leading(), Trailing(), Top(), Bottom())
        backgroundImageViewMask.layer.masksToBounds = false
        backgroundImageView.easy.layout(Edges(1))
        backgroundImageView.contentMode = .scaleAspectFill
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonClicked)))
    }
    
    func setupData(_ viewModel : CardViewModel?){
        self.viewModel = viewModel
        
        guard let model = self.viewModel else { return }
        if model.isTamplateCard {
            setupTemplateCardDesign()
            return
        }
        backgroundImageView.setImage(imageURL: URL(string: model.mainImageURL), placeholder: Images.imagePlaceholder.uiimage())
        bottomTextBlockView.set(model.title, model.description)
        downloadsCounterView.setIcon(.download)
        downloadsCounterView.setText(String(model.dowloadsCount))
    }
    
    private func setupTemplateCardDesign(){
        guard let model = self.viewModel else { return }
        actionButton.removeFromSuperview()
        backgroundImageView.image = Images.imagePlaceholder.uiimage()
        downloadsCounterView.setIcon(.cloud)
        downloadsCounterView.setText("...")
        bottomTextBlockView.set(model.title, model.description)
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        if viewModel == nil {return}
        if viewModel!.isTamplateCard == false {
            onCardPress?(self,viewModel!)
        }
    }
    
}
