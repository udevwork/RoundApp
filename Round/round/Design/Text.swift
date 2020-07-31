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
        case regular
        case light
        
        func data() -> ( fontName: FontNames, size : CGFloat) {
            switch self {
            case .window:
                return (.BellotaRegular, 21)
            case .title:
                return (.PlayBold, 21)
            case .article:
                return (.BellotaBold, 18)
            case .regular:
                return (.BellotaRegular, 13)
            case .light:
                return (.BellotaLight, 11)
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
