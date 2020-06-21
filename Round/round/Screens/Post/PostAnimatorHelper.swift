//
//  PostAnimatorHelper.swift
//  round
//
//  Created by Denis Kotelnikov on 21.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit

class PostAnimatorHelper {
   private static var cardOriginalFrame : [CGRect] = []
    
    static func pop() -> CGRect{
       return cardOriginalFrame.removeLast()
    }
    static func push(cardFrame: CGRect){
        cardOriginalFrame.append(cardFrame)
    }
}
