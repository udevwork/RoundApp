//
//  Design.swift
//  round
//
//  Created by Denis Kotelnikov on 20.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class Design {
    
    static var safeArea : UIEdgeInsets {
        let w = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return w?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

enum FontNames : String {
    case BellotaRegular = "BellotaText-Regular"
    case BellotaLight =  "BellotaText-Light"
    case BellotaBold = "BellotaText-Bold"
    
    case PlaySemiBold =  "PlayfairDisplay-SemiBold"
    case PlayRegular =  "PlayfairDisplay-Regular"
    case PlayMedium =  "PlayfairDisplay-Medium"
    case PlayBold =  "PlayfairDisplay-Bold"
    case PlayBlack =  "PlayfairDisplay-Black"
    
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
    case Post
    case Avatar
    
    func data() -> (radius: CGFloat, offset : CGSize, opacity : Float, color : UIColor) {
        switch self {
        case .NavigationBar:
            return (10, .zero, 0.6, .black)
        case .Button:
            return (7, .zero, 0.3, .black)
        case .Post:
            return (25, .init(width: 0, height: 15), 0.5, #colorLiteral(red: 0.3450980392, green: 0.4666666667, blue: 0.6352941176, alpha: 1))
        case .Avatar:
            return (15, .init(width: 0, height: 10), 0.3, .black)
        }
    }
}

enum Colors: String {
    case vcBackground = "viewControllerBackground"
    case label = "contrastLabel"
    case lightlabel = "lightLabel"
    case lightblue = "blue" // use for shadows

    
    func uicolor() -> UIColor {
        if let color = UIColor(named: self.rawValue) {
            return color
        } else {
            Debug.log("Design.swift COLOR ERROR")
            return .green
        }
    }
    func cgcolor() -> CGColor {
        if let color = UIColor(named: self.rawValue) {
            return color.cgColor
        } else {
            Debug.log("Design.swift COLOR ERROR")
            return UIColor.green.cgColor
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
    case house           = "house.fill"
    case clock           = "clock"

    case checkmark       = "checkmark.circle.fill"
    case xmarkOctagon    = "xmark.octagon.fill"
    case cloudError      = "xmark.icloud.fill"
    case eye             = "eye.fill"
    case download        = "tray.and.arrow.down.fill"
    case tableEdit       = "table.badge.more.fill"
    case numberList      = "list.number"
    case arrowShare      = "arrowshape.turn.up.right.fill"
    
    case alignleft       = "text.alignleft"
    case aligncenter     = "text.aligncenter"
    case alignright      = "text.alignright"
    case bold            = "bold"
    case chevronDown     = "chevron.down"
    case chevronLeft     = "chevron.left"
    case settings        = "slider.horizontal.3"
    case settingsGear    = "gear"

    func image(weight: UIImage.SymbolWeight = .black) -> UIImage {
        if let img = UIImage(systemName: self.rawValue, withConfiguration: UIImage.SymbolConfiguration(weight: weight)){
        return img
        } else {
            Debug.log("Design.swift ERROR")
            return UIImage(named: "empty")!
        }
    }
}

enum Images : String {
    case avatarPlaceholder   = "avatarPlaceholder"
    case imagePlaceholder    = "ImagePlaceholder"
    
    func uiimage() -> UIImage {
        if let img = UIImage(named: self.rawValue){
            return img
        } else {
            Debug.log("Design.swift Images ERROR")
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
