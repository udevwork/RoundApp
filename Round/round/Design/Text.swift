//
//  Text.swift
//  round
//
//  Created by Denis Kotelnikov on 20.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit


class Text: UILabel {
    
    init(frame: CGRect = .zero, fontName: FontNames = .Regular, size : CGFloat = 12) {
        super.init(frame: frame)
        font = UIFont(name: fontName.rawValue, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animatedTextChanging(time: TimeInterval, text : String){
        UIView.animate(withDuration: time, animations: {
            self.alpha = 0
        }) { ok in
            UIView.animate(withDuration: time, animations: {
                self.text = text
                self.alpha = 1
            })
        }
    }
}
