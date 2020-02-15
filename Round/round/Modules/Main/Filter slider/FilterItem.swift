//
//  FilterItem.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit

protocol FilterItem : UICollectionViewCell{
    var onPress : ()->() { get set }
    func setup(text : String)
}
