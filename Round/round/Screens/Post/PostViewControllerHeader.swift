//
//  PostViewControllerHeader.swift
//  round
//
//  Created by Denis Kotelnikov on 26.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import EasyPeasy

class PostViewControllerHeader: UIView {
    
    var backgroundImageView : UIImageView = UIImageView()
    var isSubscribed: Bool = false
    
    let backButton : IconLableBluredView = IconLableBluredView(icon: .back, text: "Back")
    
    let bottomTextBlockView: PostBluredTitleDescriptionView = PostBluredTitleDescriptionView()
    
    init(frame: CGRect, viewModel: CardViewModel, card: CardView) {
        super.init(frame: frame)
        backgroundImageView.image = card.backgroundImageView.image
        setupDesign(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func setupDesign(_ viewModel : CardViewModel){
        bottomTextBlockView.set(viewModel.title, viewModel.description)
        addSubview(backgroundImageView)
        addSubview(bottomTextBlockView)
        
            addSubview(backButton)
        
        backButton.easy.layout(Leading(20),Top(20+Design.safeArea.top))
               
        bottomTextBlockView.easy.layout(Leading(15), Trailing(15), Bottom(15))
        
        backgroundImageView.easy.layout(
            Top(),Leading(),Trailing(),Bottom()
        )
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.masksToBounds = true
        layoutSubviews()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let bigCheck = backButton.frame.insetBy(dx: -20, dy: -20)
        if bigCheck.contains(point) {
            return backButton
        }
        return super.hitTest(point, with: event)
    }
    
    public var onAvatarPress : ()->() = { }
    
    @objc func routeToProfile(){
        onAvatarPress()
    }
}
