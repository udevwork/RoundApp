//
//  Tutorial.swift
//  round
//
//  Created by Denis Kotelnikov on 05.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//


import Foundation
import UIKit

class Tutorial: UIViewController {
    
    private let background: UIView = UIView()
    private let fingerImage: UIImageView = UIImageView(image: Icons.handPointer.image())
    private let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tapGesture.addTarget(self, action: #selector(onTap))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func showHorizontalTotarial(){
        
    }
    
    public func showVerticalTotarial(){
        
    }
    
    @objc func onTap(){
        
    }
}
