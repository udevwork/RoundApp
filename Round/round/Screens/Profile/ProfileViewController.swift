//
//  ProfileViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 05.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ProfileViewController: BaseViewController<ProfileViewModel> {
    let authorAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let titleLabel : Text = Text(.article,  .black)
    let nameeInput: InputField = InputField(icon: Icons.user, placeHolder: "username")

    
    let addAccountButton : Button = ButtonBuilder()
    .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
    .setStyle(.text)
    .setText("_")
    .setTextColor(.white)
    .setCornerRadius(13)
    .build()
    
    let signInButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.text)
        .setText("signIn")
        .setTextColor(.white)
        .setCornerRadius(13)
        .build()
    
    let saveUserInfoButton : Button = ButtonBuilder()
    .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
    .setStyle(.text)
    .setText("save info")
    .setTextColor(.white)
    .setCornerRadius(13)
    .build()
    
    override init(viewModel: ProfileViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Profile"
        
        if viewModel.user.isAnonymus{
            authorAvatar.setImage("avatarPlaceholder")
            titleLabel.text = "anonymous"
        } else {
            authorAvatar.setImage("avatarPlaceholder")
            titleLabel.text = viewModel.user.userName
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("CURRENT ID: ",AccountManager.shared.getCurrentUser().ID)
    }
    
    private func setupView() {
        [authorAvatar,titleLabel,signInButton,addAccountButton,nameeInput,saveUserInfoButton].forEach {
            view.addSubview($0)
        }
        
        authorAvatar.easy.layout(Top(100),Leading(20),Width(40),Height(40))
        titleLabel.easy.layout(Leading(10).to(authorAvatar,.trailing),CenterY().to(authorAvatar))
        titleLabel.sizeToFit()
        signInButton.easy.layout(Leading(20), Top(20).to(authorAvatar,.bottom))
        addAccountButton.easy.layout(Leading(20), Top(20).to(signInButton,.bottom))
        nameeInput.easy.layout(Leading(20), Top(20).to(addAccountButton,.bottom),Trailing(20), Height(50))
        saveUserInfoButton.easy.layout(Leading(20), Top(20).to(nameeInput,.bottom))
        
        signInButton.setTarget {
            print("SignInButton")
            let vc = SignInRouter.assembly(model: SignInViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }
        addAccountButton.setTarget {
            print("addAccountButton")
            let vc = LoginPageRouter.assembly(model: LoginPageViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }
        saveUserInfoButton.setTarget {
            print("saveUserInfoButton")
            AccountManager.shared.saveUserName(newName: self.nameeInput.input.text!)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoLibrary))
        authorAvatar.addGestureRecognizer(tap)
    }
    
    var photoPicker: UIImagePickerController?
    @objc func photoLibrary(){
        if viewModel.user.isAnonymus { return }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            photoPicker = UIImagePickerController()
            photoPicker!.delegate = self
            photoPicker!.sourceType = .photoLibrary
            present(photoPicker!, animated: true, completion: nil)
        }
    }
    
    func saveImage(){
        guard let imageToUpload = authorAvatar.image else {return}
        Network().uploadImage(uiImage: imageToUpload) { result in
            print("OK")
        }
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            authorAvatar.setImage(image)
            photoPicker!.dismiss(animated: true, completion: nil)
            saveImage()
        } else{
            print("Something went wrong in  image")
        }

    }
}
