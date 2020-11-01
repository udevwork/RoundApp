//
//  IconEditorSlider.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import EasyPeasy

class IconEditorSlider: UIView {
        
    let slider: UISlider = UISlider()
    let label: Text = Text(.light, .label)
    var onSliderChange: ((Float)->())?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(slider)
        slider.easy.layout(CenterY(10), Leading(60), Trailing(60))
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        self.alpha = 0
        self.frame = self.frame.offsetBy(dx: 0, dy: -10)
        slider.thumbTintColor = .white
        slider.minimumTrackTintColor = .systemGray
        slider.maximumTrackTintColor = .systemGray5
        addSubview(label)
        label.easy.layout(Bottom(-25),Leading(),Trailing(),Height(15))
        label.layer.masksToBounds = false
        label.textAlignment = .center
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        onSliderChange?(sender.value)
    }
    
    public func animate(show: Bool){
        if show {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
                self.isUserInteractionEnabled = true
                self.transform = CGAffineTransform(translationX: 0, y: -10)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.label.animatedTextChanging(time: 0.2, text: "")
                self.alpha = 0
                self.isUserInteractionEnabled = false
                self.transform = CGAffineTransform(translationX: 0, y: 10)
            }
        }
    }
    
}
