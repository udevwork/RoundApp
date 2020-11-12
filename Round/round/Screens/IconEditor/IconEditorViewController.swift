//
//  IconEditorViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class IconEditorViewController: BaseViewController<IconEditorViewModel> {
        
    let instruments: IconEditorInstruments = IconEditorInstruments()
    let slider: IconEditorSlider = IconEditorSlider()
    
    
    let editingIconContainer: UIView = UIView()
    let iconToEdit: UIImageView = UIImageView()
    let backgroundColor: UIImageView = UIImageView()
    let backgroundImage: UIImageView = UIImageView()
    
    
    override init(viewModel: IconEditorViewModel) {
        super.init(viewModel: viewModel)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title = localized(.iconEditor)
    }
    
    
    func setupView(){
        view.addSubview(editingIconContainer)
        
        editingIconContainer.addSubview(backgroundColor)
        
        backgroundColor.addSubview(backgroundImage)
        backgroundImage.easy.layout(Edges())
        backgroundImage.contentMode = .scaleAspectFit
        let iconBackgroundsize: CGSize =
            CGSize(width: UIScreen.main.bounds.width - 90,
                   height: UIScreen.main.bounds.width - 90)
        backgroundColor.easy.layout(Size(iconBackgroundsize), Center())
        backgroundColor.layer.masksToBounds = true
        backgroundColor.addSubview(iconToEdit)
        backgroundColor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePress)))
        backgroundColor.isUserInteractionEnabled = true
        backgroundColor.backgroundColor = .systemGray2
        backgroundColor.layer.cornerRadius = 50
        
        let iconsize: CGSize = CGSize(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
        iconToEdit.easy.layout(Size(iconsize), Center())
        iconToEdit.image = UIImage(systemName: "square.stack.3d.up.fill")
        iconToEdit.tintColor = .white
        viewModel.backgroundImage = backgroundImage
        viewModel.backgroundColor = backgroundColor
        viewModel.icon = iconToEdit
        viewModel.slider = slider
        instruments.delegate = self
        view.addSubview(instruments)
        instruments.easy.layout(Leading(),Trailing(), Bottom(100), Height(100))
        
        view.addSubview(slider)
        slider.easy.layout(Trailing(),Leading(),Bottom().to(instruments,.top), Height(30))
        editingIconContainer.easy.layout(Top(20), Bottom(20).to(slider), Leading(40), Trailing(40))

    }

    @objc func imagePress(){
        slider.animate(show: false)
    }
    
}

extension IconEditorViewController: IconEditorInstrumentsDelegate {
    
    func editor(countOfForInstrument instruments: IconEditorInstruments) -> Int {
        return viewModel.instruments.count
    }
    
    func editor(indexForInstrument: Int, in instruments: IconEditorInstruments) -> EditorIntsrument {
        return viewModel.instruments[indexForInstrument]
    }

}
