//
//  BasePostCell.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

enum PostCellType : Int, Codable {
    case Title = 0
    case Article
    case SimplePhoto
    case Gallery
    case Download
}

protocol BasePostCellViewModelProtocol {
    var type : PostCellType? { get set }
    var order : Int? {get set}
}

protocol BasePostCellProtocol :  UITableViewCell {
    var id : String { get }
    var postType : PostCellType { get }
    func setup(viewModel : BasePostCellViewModelProtocol)
    func setupDesign()
    func setPadding(padding: UIEdgeInsets)
}

