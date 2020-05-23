//
//  UIImageExtension.swift
//  round
//
//  Created by Denis Kotelnikov on 26.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {

        guard let img = self.cgImage, let provider = img.dataProvider else {
            debugPrint("no image no provider")
            return .black
        }
        
        let pixelData = provider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
