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
    
    enum Style {
        case window
        case title
        case article
        
        func data() -> ( fontName: FontNames, size : CGFloat, color : UIColor) {
            switch self {
            case .window:
                return (.Bold, 21, .black)
            case .title:
                return (.Bold, 31, .black)
            case .article:
                return (.Medium, 16, .black)
            }
        }
    }
    
    
    init(_ style : Style, _ color : UIColor? = nil, _ frame: CGRect? = nil) {
        if frame == nil {
            super.init(frame: .zero)
        } else { super.init(frame: frame!) }
        
        font = UIFont(name: style.data().fontName.rawValue, size: style.data().size)
        
        if color == nil {
            textColor = style.data().color
        } else {
            textColor = color
        }
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
