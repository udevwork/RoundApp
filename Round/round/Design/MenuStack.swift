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
    private let bluredView: UIView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        
    init(size: CGSize) {
        
        stask.alignment = .center
        stask.distribution = .equalCentering
        stask.axis = .horizontal
        
        super.init(frame: .init(origin: .zero, size: size))
        addSubview(bluredView)
        addSubview(stask)
        bluredView.easy.layout(Edges())
        stask.easy.layout(CenterY(),Leading(90),Trailing(90))

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bluredView.layer.cornerRadius = 30
        bluredView.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: bluredView.frame).cgPath
        self.layer.shadowRadius = 14
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = Colors.lightblue.cgcolor()
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
        let biggerFrame = icon.frame.insetBy(dx: -20, dy: -20)
        return biggerFrame.contains(point) ? icon : super.hitTest(point, with: event)
    }
}
