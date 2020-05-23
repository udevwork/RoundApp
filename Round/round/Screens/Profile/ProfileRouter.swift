//
//  ProfileRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class ProfileRouter: RouterProtocol {
    
    typealias viewControllerModel = ProfileViewModel
    typealias viewController = ProfileViewController
    
    weak var controller: ProfileViewController?
    
    static func assembly(userId: String) -> ProfileViewController {
        let model : ProfileViewModel = ProfileViewModel(userId: userId)
        model.router = ProfileRouter()
        let vc : ProfileViewController = ProfileViewController(viewModel: model)
        model.router?.controller = vc
        return vc
    }
    
    func showBookmarks() {
        let vc = BookmarksViewController(viewModel: BookmarksViewModel())
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    func showProfileEditor(delegate: ProfileEditorDelegate) {
        let model: ProfileEditorViewModel = ProfileEditorViewModel(userName: controller!.viewModel.userName, userAvatar: controller!.header.userAvatar.image!)
        let vc = ProfileEditorRouter.assembly(model: model)
        vc.delegate = delegate
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    func showPostEditor() {
        let vc = PostEditorRouter.assembly()
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("ProfileRouter DEINIT")
    }
}
