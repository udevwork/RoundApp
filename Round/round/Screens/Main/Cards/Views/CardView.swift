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
    let backgroundImageView : UIImageView = UIImageView(image: Images.imagePlaceholder.uiimage())
    let backgroundImageViewMask : UIView = UIView()
    let actionButton : UIButton = UIButton()
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
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
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 25
        clipsToBounds = false
        backgroundImageView.layer.cornerRadius = 25
        backgroundImageView.layer.masksToBounds = true
        backgroundImageViewMask.addSubview(backgroundImageView)
        addSubview(backgroundImageViewMask)
        backgroundImageViewMask.addSubview(bottomTextBlockView)
        [actionButton, downloadsCounterView].forEach { addSubview($0) }
        downloadsCounterView.easy.layout(Top(20),Leading(20))
        backgroundImageViewMask.easy.layout(Leading(), Trailing(), Top(), Bottom())
        backgroundImageViewMask.layer.masksToBounds = false
        backgroundImageView.easy.layout(Edges(1))
        backgroundImageView.contentMode = .scaleAspectFill
        bottomTextBlockView.easy.layout(Leading(20), Trailing(20), Bottom(20))
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
        backgroundImageView.image = Images.postLoadingTemplate.uiimage()
        downloadsCounterView.setIcon(.cloud)
        downloadsCounterView.setText("...")
        bottomTextBlockView.set(model.title, model.description)
        addSubview(loadingIndicator)
        loadingIndicator.easy.layout(Center())
        loadingIndicator.startAnimating()
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        if viewModel == nil {return}
        if viewModel!.isTamplateCard == false {
            onCardPress?(self,viewModel!)
        }
    }
    
}
