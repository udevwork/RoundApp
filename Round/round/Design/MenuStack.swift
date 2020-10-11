//
//  MenuStack.swift
//  round
//
//  Created by Denis Kotelnikov on 29.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class MenuStack: UIView {
    
    private let stask: UIStackView = UIStackView()
    //private let bluredView: UIView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    private let backgroundView: UIView = UIView()

    init(size: CGSize) {
        
        stask.alignment = .center
        stask.distribution = .equalCentering
        stask.axis = .horizontal
        
        super.init(frame: .init(origin: .zero, size: size))
        addSubview(backgroundView)
        addSubview(stask)
        backgroundView.easy.layout(Edges())
        stask.easy.layout(CenterY(),Leading(50),Trailing(50))

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = frame.height / 2
        backgroundView.layer.masksToBounds = true
        backgroundView.backgroundColor = Colors.stackMenuColor.uicolor()
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: backgroundView.frame).cgPath
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func append(_ view: MenuStackElement) {
        stask.addArrangedSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuStackElement: UIView {
    let icon: UIImageView = UIImageView()
    private let onTap: ()->()
    init(icon: Icons, onTap: @escaping ()->()) {
        self.onTap = onTap
        self.icon.image = icon.image()
        self.icon.tintColor = .white
        self.icon.contentMode = .scaleAspectFit
        super.init(frame: .zero)
        addSubview(self.icon)
        self.icon.easy.layout(Edges())
        self.icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPress) ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onPress(){
        onTap()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let biggerFrame = icon.frame.insetBy(dx: -40, dy: -40)
        return biggerFrame.contains(point) ? icon : super.hitTest(point, with: event)
    }
}
