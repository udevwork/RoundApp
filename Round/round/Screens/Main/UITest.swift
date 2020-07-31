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
    let viewToTest: UserAvatarNameDate = UserAvatarNameDate(URL(string: "https://www.gravatar.com/avatar/789ad08862abcdfbca8beec84e4998d9?s=32&d=identicon&r=PG"), "Arek Holko", Timestamp(date: Date()))
    
    
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
