//
//  MainMenu.swift
//  round
//
//  Created by Denis Kotelnikov on 04.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class MainMenu: UIView {
    
   private let backgroundView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = .white
        v.alpha = 0.3
        return v
    }()
    
   private let stackContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 13
        return v
    }()
    
    
   private let stack: UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.distribution = .fill
        s.axis = .vertical
        return s
    }()
    
    private func setUp(){
        addSubview(backgroundView)
        addSubview(stackContainer)
        stackContainer.addSubview(stack)
        stackContainer.easy.layout(Top(50),Leading(50),Bottom(50),Trailing(50))
        stack.easy.layout(Edges(5))
    }
    
    init(_ elements: [MainMenuElementModel]) {
        super.init(frame: .zero)
        setUp()
        add(elements)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func add(_ elements: [MainMenuElementModel]) {
        elements.forEach { model in
            stack.addArrangedSubview(MainMenuElementView(model: model))
        }
        layoutSubviews()
    }
}

class MainMenuElementView : UIView {
    init(model: MainMenuElementModel) {
        super.init(frame: .zero)
        let button : Button = ButtonBuilder()
            .setFrame(CGRect(origin: .zero, size: .zero))
            .setStyle(.text)
            .setText(model.text)
            .setTextColor(.black)
            .setColor(.clear)
            .setTarget { model.onPress() }
            .build()
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MainMenuElementModel {
    let text: String
    let onPress: ()->()
    init(_ text: String, onPress: @escaping ()->()) {
        self.text = text
        self.onPress = onPress
    }
}
