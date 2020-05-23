//
//  RNGestureManager.swift
//  round
//
//  Created by Denis Kotelnikov on 06.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

final class RNGestureManager {
    private let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    private let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    var onTapEvent: (()->())? = nil
    var onSwipeEvent: (()->())? = nil
    public func setupGestureWith(view: UIView){
        view.addGestureRecognizer(swipeGesture)
        swipeGesture.direction = .up
        swipeGesture.addTarget(self, action: #selector(onSwipe))
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onTap))
    }
    @objc func onSwipe(recognizer: UISwipeGestureRecognizer){
        if recognizer.direction == .up{
            onSwipeEvent?()
        }
    }
    @objc func onTap(recognizer: UITapGestureRecognizer){
        if recognizer.state == .recognized {
            onTapEvent?()
        }
    }
    
}
