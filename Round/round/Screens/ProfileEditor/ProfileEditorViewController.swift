//
//  ProfileEditorViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 26.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProfileEditorViewController: BaseViewController<ProfileEditorViewModel> {
    var delegate : ProfileEditorDelegate? = nil
    let userAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    let editButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .init(width: 45, height: 45)))
        .setStyle(.icon)
        .setIcon(.crossCircle)
        .setIconSize(CGSize(width: 45, height: 45))
        .setIconColor(.white)
        .setColor(.black)
        .setCornerRadius(45/2)
        .setShadow(.Button)
        .build()
    
    let saveButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.text)
        .setText("Save")
        .setTextColor(.label)
        .setColor(.systemIndigo)
        .setCornerRadius(13)
        .build()
    
    let nameInput: InputField = InputField(icon: Icons.edit, placeHolder: "")
    
    var photoPicker: UIImagePickerController?
    
    override init(viewModel: ProfileEditorViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Edit profile"
        setupView()
    }
    
    deinit {
        print("profile editor deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    private func setupView() {
        view.addSubview(userAvatar)
        view.addSubview(nameInput)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        nameInput.input.autocorrectionType = .no
        
        if viewModel.userName == ""{
            nameInput.input.placeholder = "Author name"
        } else {
            nameInput.input.placeholder = viewModel.userName
        }
        
        userAvatar.setImage(viewModel.userAvatar)

        
        userAvatar.easy.layout(Top(70),CenterX(),Width(150),Height(150))
        editButton.easy.layout(Bottom(-10).to(userAvatar,.bottomMargin),Leading(-10).to(userAvatar,.leadingMargin),Width(45),Height(45))
        
        nameInput.easy.layout(Top(20).to(userAvatar,.bottom),Leading(20),Trailing(20), Height(50))
        saveButton.easy.layout(Top(20).to(nameInput,.bottom),Trailing(20))
        userAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoLibrary)))
        nameInput.input.addTarget(self, action: #selector(nameFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        saveButton.setTarget { [weak self] in
            self?.saveUserName()
        }
        editButton.setTarget {
            FirebaseAPI.shared.deleteImage()
        }
    }
    
    @objc func nameFieldDidChange(_ textField: UITextField) {
       // print(textField.text)
    }
    
    @objc func photoLibrary(){
        let vc = ImagePicker { [weak self] image in
            self?.userAvatar.setImage(image)
            self?.saveImage()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func saveImage(){
        guard let imageToUpload = userAvatar.image else {return}
        delegate?.profileEditor(newAvatar: imageToUpload)
        Notifications.shared.Show(RNTopActivityIndicator(text: "Saving avatar"))
        Network().uploadImage(uiImage: imageToUpload) { result in
            if result == .success {
                Notifications.shared.Show(text: "Upload complete", icon: Icons.checkmark.image(), iconColor: .systemGreen)
            }
        }
    }
    
    func saveUserName(){
        nameInput.input.endEditing(true)
        
        guard let name = nameInput.input.text else {
            return
        }
        
        if name.isEmpty {
            Notifications.shared.Show(text: "Name is empty", icon: Icons.crossCircle.image(), iconColor: .systemRed)
            return
        }
        
        if name.removingWhitespaces().count < 4 {
            Notifications.shared.Show(text: "less the 4 chars?!", icon: Icons.crossCircle.image(), iconColor: .systemRed)
            return
        }
        delegate?.profileEditor(newName: name)
        FirebaseAPI.shared.setUserName(name: name) { result in
            if result == .success {
                 Notifications.shared.Show(text: "saving name complete", icon: Icons.checkmark.image(), iconColor: .systemIndigo)
            } else {
                Notifications.shared.Show(text: "error saving name", icon: Icons.crossCircle.image(), iconColor: .systemRed)
            }
        }
    }
}
