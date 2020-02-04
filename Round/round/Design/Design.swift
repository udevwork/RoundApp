//
//  Design.swift
//  round
//
//  Created by Denis Kotelnikov on 20.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

enum FontNames : String {
    case ExtraLight = "Gentleman-ExtraLight"
    case Regular = "Gentleman-Regular"
    case Light =  "Gentleman-Light"
    case Bold = "Gentleman-Bold"
    case Thin =  "Gentleman-Thin"
    case Book =  "Gentleman-Book"
    case Medium =  "Gentleman-Medium"
    case Heavy =  "Gentleman-Heavy"
    case Black =  "Gentleman-Black"
    
    func printAllAvalableFontFamilys() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            Debug.log("FONTS: ", "Family: \(family) Font names: \(names)")
        }
    }
}

enum ShadowPresets  {
    case NavigationBar
    case Button
    
    func data() -> (radius: CGFloat, offset : CGSize, opacity : Float, color : UIColor) {
        switch self {
        case .NavigationBar:
            return (10, .zero, 0.6, .black)
        case .Button:
            return (10, .zero, 0.6, .black)
        }
    }
    
}

extension UIColor {
    static let viewControllersBackgroung = #colorLiteral(red: 0.8745098039, green: 0.9176470588, blue: 0.9529411765, alpha: 1)
    static let text = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
    static let selected = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 1, alpha: 1)
    static let secondaryViews = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let button = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let cardGradient = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65)

}

class Icons {
    static let back : UIImage = #imageLiteral(resourceName: "back")
    static let menu : UIImage = #imageLiteral(resourceName: "MenuIcon")
    static let account : UIImage = #imageLiteral(resourceName: "012-user")
    static let location : UIImage = #imageLiteral(resourceName: "007-pin")
    static let settings : UIImage = #imageLiteral(resourceName: "011-settings")
    static let compas : UIImage = #imageLiteral(resourceName: "019-compass")
    static let cloud : UIImage = #imageLiteral(resourceName: "016-ui")
    static let search : UIImage = #imageLiteral(resourceName: "023-magnifying-glass")
    
}

extension CAGradientLayer {
    
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}

extension UIView {
    func roundCorners(corners: CACornerMask, radius: CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        /// layerMaxXMaxYCorner  -  right botton
        /// layerMaxXMinYCorner   -  right top
        /// layerMinXMaxYCorner   -  left bottom
        /// layerMinXMaxYCorner   -  left top
    }
    
    func setupShadow(radius: CGFloat = 1, offset : CGSize = .zero, opacity : Float = 0.5, color : UIColor = .black) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    
    func setupShadow(preset: ShadowPresets) {
        layer.masksToBounds = false
        layer.shadowColor = preset.data().color.cgColor
        layer.shadowOffset = preset.data().offset
        layer.shadowRadius = preset.data().radius
        layer.shadowOpacity = preset.data().opacity
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
