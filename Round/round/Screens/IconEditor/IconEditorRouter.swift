//
//  IconEditorRouter.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
class IconEditorRouter : NSObject {
    weak var view: UIViewController?
    
    var onColorPicked: ((UIColor)->())?
    var onImagePicked: ((UIImage)->())?

    
    static func assembly() -> IconEditorViewController {
        let router = IconEditorRouter()
        let model = IconEditorViewModel(router: router)
        let vc = IconEditorViewController(viewModel: model)
        router.view = vc
        return vc
    }
    
    public func showColorPicker(onColorPicked: @escaping (UIColor)->()){
        self.onColorPicked = onColorPicked
        let picker = UIColorPickerViewController()
        picker.delegate = self
        view?.present(picker, animated: true, completion: nil)
    }
    
    public func showIconsPicker(onSelectImage: @escaping (UIImage)->()){
        let picker = IconEditorIconsListViewController()
        picker.onSelectImage = onSelectImage
        view?.present(picker, animated: true, completion: nil)
    }
    
    public func backgroundImagePicker(onSelectImage: @escaping (UIImage)->()){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.onImagePicked = onSelectImage
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            view?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func saveImageAlert(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            Notifications.shared.Show(RNSimpleView(text: localized(.editorIconSaveError), icon: Icons.cross.image(), iconColor: .systemRed))
        } else {
            Notifications.shared.Show(RNSimpleView(text: localized(.editorIconSaved), icon: Icons.checkmark.image(), iconColor: .systemGreen))
        }
    }
    
}

extension IconEditorRouter: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        onColorPicked?(viewController.selectedColor)
    }
}


extension IconEditorRouter: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        onImagePicked?(image)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
