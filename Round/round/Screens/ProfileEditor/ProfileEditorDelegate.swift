//
//  ProfileEditorDelegate.swift
//  round
//
//  Created by Denis Kotelnikov on 10.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileEditorDelegate {
    func profileEditor(newName: String)
    func profileEditor(newAvatar: UIImage)
}
