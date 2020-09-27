//
//  DownloadViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class DownloadViewController: UIViewController{
    
    init(link: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
