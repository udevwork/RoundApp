//
//  EditorIntsrument.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

protocol EditorIntsrument {
    var icon: UIImage { get }
    var lableText: String { get }
    var onPress: ()->() { get }
}

struct ColorInstrument: EditorIntsrument {
    var icon: UIImage
    var lableText: String
    var onPress: () -> ()
}

