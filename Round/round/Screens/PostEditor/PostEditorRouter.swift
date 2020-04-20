//
//  PostEditorRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 09.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class PostEditorRouter: RouterProtocol {
    typealias viewControllerModel = PostEditorViewModel
    typealias viewController = PostEdtorViewController
    
    weak var controller: PostEdtorViewController?
    
    static func assembly() -> PostEdtorViewController {
        
        let model: PostEditorViewModel = PostEditorViewModel()
        
        model.router = PostEditorRouter()
        
        let vc = PostEdtorViewController(viewModel: model)
        
        model.router?.controller = vc

        return vc
    }
    
    func ShowPhotoPicker(onImageSelect: @escaping (UIImage)->()) {
        let picker: ImagePicker = ImagePicker(onImageSelect: onImageSelect)
        controller?.present(picker, animated: true, completion: nil)
    }
    func ShowBlockPicker(onBlockSelect: @escaping (PostBlockSelectorModel.Types)->()) {
        let model = PostBlockSelectorModel(onBlockSelect: onBlockSelect)
        let picker = PostBlockSelectorViewController(viewModel: model)
        controller?.present(picker, animated: true, completion: nil)
    }
    
}
