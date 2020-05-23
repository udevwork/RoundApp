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
    func uiFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
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

enum Icons : String {
    case add             = "plus.circle.fill"
    case bookmarkfill    = "bookmark.fill"
    case bookmark        = "bookmark"
    case pin             = "mappin.and.ellipse"
    case user            = "person.crop.circle.fill"
    case noUser          = "person.crop.circle.badge.xmark"
    case wifiError       = "wifi.exclamationmark"
    case search          = "magnifyingglass.circle.fill"
    case back            = "arrow.left"
    case menu            = "MenuIcon"
    case cross           = "xmark"
    case crossCircle     = "xmark.circle.fill"
    case filter          = "line.horizontal.3.decrease.circle.fill"
    case gallery         = "photo"
    case email           = "envelope.circle.fill"
    case emailCircle     = "envelope.circle"
    case password        = "lock.circle.fill"
    case edit            = "pencil"
    case fieldEdit       = "pencil.and.ellipsis.rectangle"
    case editInCircle    = "pencil.circle.fill"
    case editorAddPhoto  = "photo.fill.on.rectangle.fill"
    case logIn           = "025-login"
    case logOut          = "024-logout"
    case addPostBlock    = "rectangle.stack.fill.badge.plus"
    case trash           = "trash.fill"
    case trashCross      = "trash.slash.fill"

    case checkmark       = "checkmark.circle.fill"
    case xmarkOctagon    = "xmark.octagon.fill"
    case cloudError      = "xmark.icloud.fill"
    case eye             = "eye.fill"
    case tableEdit       = "table.badge.more.fill"
    case numberList      = "list.number"
    case arrowShare      = "arrowshape.turn.up.right.fill"
    
    case alignleft       = "text.alignleft"
    case aligncenter     = "text.aligncenter"
    case alignright      = "text.alignright"
    case bold            = "bold"
    
    func image() -> UIImage {
        if let img = UIImage(systemName: self.rawValue) {
        return img
        } else {
            Debug.log("Design.swift ERROR")
            return UIImage(named: "empty")!
        }
    }
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
