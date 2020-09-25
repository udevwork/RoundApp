//
//  PostAnimatorHelper.swift
//  round
//
//  Created by Denis Kotelnikov on 21.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit

public class PostAnimatorHelper {
    private static var cardOriginalFrame : [PostAnimationsTempData] = []
    
    static func pop() -> PostAnimationsTempData{
        return cardOriginalFrame.removeLast()
    }
    static func push(_ tempData: PostAnimationsTempData){
        cardOriginalFrame.append(tempData)
    }
}

public struct PostAnimationsTempData {
    var mainPicOriginalFrame: CGRect
    var viewsCounterOriginalFrame: CGRect
    var selectedCard: UIView
}
