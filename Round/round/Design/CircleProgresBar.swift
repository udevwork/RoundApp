//
//  CircleProgresBar.swift
//  round
//
//  Created by Denis Kotelnikov on 02.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class CircleProgresBar: UIView {
    
    let label: Text = Text(.article, .label)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
    }
    
    private func setupProgressBar(){
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let path : UIBezierPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
    }
}
