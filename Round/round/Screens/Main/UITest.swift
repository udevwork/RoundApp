//
//  UITest.swift
//  round
//
//  Created by Denis Kotelnikov on 30.07.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Firebase


class UITest: UIViewController {
    let viewToTest = IconLableBluredView(icon: .back, text: "Back", {
        print("lol")
    })
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(viewToTest)
        viewToTest.easy.layout(Leading(20),CenterY())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
