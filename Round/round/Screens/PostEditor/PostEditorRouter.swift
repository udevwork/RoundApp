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
    func showLocationAlert(){
        let message = "Allow access to your location. This will allow us to improve the application."
        let title = "Your location"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openSettingAction: UIAlertAction = UIAlertAction(title: "Allow", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        alert.addAction(cancelAction)
        alert.addAction(openSettingAction)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func showLocationUseAlert(l: Location, onUse: @escaping ()->()){
        let message = "\(l.country ?? ""), \(l.city ?? ""), \(l.street ?? "")"
        let title = "Use this location?"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openSettingAction: UIAlertAction = UIAlertAction(title: "Use", style: .default, handler: { action in
            onUse()
        })
        alert.addAction(cancelAction)
        alert.addAction(openSettingAction)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func showValidationAlert(requirements: [String]){
        let title = "Something needs to be done"
        var message = ""
        requirements.forEach { rec in
            message.append(contentsOf: "\(rec)\n")
        }
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let openSettingAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(openSettingAction)
        controller?.present(alert, animated: true, completion: nil)
    }
    
    func showPostSaveAlert(onSave: @escaping ()->()){
        let title = "Do you want to publish?"
        let message = "You can find your post in your profile"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openSettingAction: UIAlertAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            onSave()
        })
        alert.addAction(cancelAction)
        alert.addAction(openSettingAction)
        controller?.present(alert, animated: true, completion: nil)
    }
}
