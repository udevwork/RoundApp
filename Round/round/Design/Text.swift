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
        case big
        case price
        case window
        case title
        case article
        case system
        case regular
        case small
        case light
        
        func data() -> ( fontName: FontNames, size : CGFloat) {
            switch self {
            case .big:
                return (.BellotaBold, 27)
            case .window:
                return (.BellotaRegular, 21)
            case .title:
                return (.BellotaBold, 21)
            case .article:
                return (.BellotaBold, 18)
            case .system:
                return (.BellotaBold, 15)
            case .regular:
                return (.BellotaRegular, 13)
            case .small:
                return (.BellotaRegular, 11)
            case .light:
                return (.BellotaLight, 11)
            case .price:
                return (.PlayBlack, 20)
            }
        }
    }
    
    
    init(_ style : Style, _ color : UIColor? = .label, _ frame: CGRect = .zero) {
        super.init(frame: frame)
        font = UIFont(name: style.data().fontName.rawValue, size: style.data().size)
        textColor = color
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
