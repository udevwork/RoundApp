//
//  BasePostCell.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

enum PostCellType {
    case Title
    case Article
    case SimplePhoto

}

protocol BasePostCellViewModelProtocol {
    var postType : PostCellType { get set }
}

protocol BasePostCellProtocol :  UITableViewCell {
    var id : String { get }
    var postType : PostCellType { get }
    func setup(viewModel : BasePostCellViewModelProtocol)
    func setupDesign()
}

