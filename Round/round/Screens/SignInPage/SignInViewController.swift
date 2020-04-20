//
//  SignInViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SignInViewController: BaseViewController<SignInViewModel> {
    
    let emailInput: InputField = InputField(icon: Icons.email, placeHolder: "email")
    let passwordInput: InputField = InputField(icon: Icons.password, placeHolder: "password")
    
    let signinButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setText("sign in")
        .setTextColor(.white)
        .setIcon(Icons.logIn.image())
        .setCornerRadius(13)
        .build()
    
    let createButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setText("create")
        .setTextColor(.white)
        .setIcon(Icons.add.image())
        .setCornerRadius(13)
        .build()
    
    let signoutButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setText("SIGNOUT")
        .setTextColor(.white)
        .setIcon(Icons.logOut.image())
        .setCornerRadius(13)
        .build()
    
    override init(viewModel: SignInViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Sign in"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        [passwordInput,emailInput,signinButton,createButton,signoutButton].forEach {
            view.addSubview($0)
        }
        
        createButton.setTarget {
            Network().createNewUser(email: self.emailInput.input.text!, password: self.passwordInput.input.text!) { (result, user) in
                if result == .success {
                    debugPrint("success")
                    debugPrint("USER: \(user?.userName ?? "no name"), \(user?.uid ?? "no id")")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    debugPrint("error")
                }
            }
        }
        
        signinButton.setTarget {
            Network().signIn(email: self.emailInput.input.text!, password: self.passwordInput.input.text!) { (result, user) in
                if result == .success {
                    UserDefaults.standard.set(self.emailInput.input.text!, forKey: "email")
                    UserDefaults.standard.set(self.passwordInput.input.text!, forKey: "password")
                    
                    debugPrint("success")
                    debugPrint("USER: \(user?.userName ?? "no name"), \(user?.uid ?? "no id")")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    debugPrint("error")
                }
            }
        }
        
        signoutButton.setTarget {
            Network().signOut { result in
                if result == .success {
                    debugPrint("success")
                } else {
                    debugPrint("error")
                }
            }
        }
        
        emailInput.easy.layout(Top(100),Leading(20),Trailing(20), Height(50))
        passwordInput.easy.layout(Top(20).to(emailInput),Leading(20),Trailing(20), Height(50))
        signinButton.easy.layout(Top(20).to(passwordInput),Leading(20))
        createButton.easy.layout(Top(20).to(passwordInput),Leading(20).to(signinButton))
        signoutButton.easy.layout(Top(20).to(passwordInput),Leading(20).to(createButton))
        
        //        loginInput.input.addTarget(self, action: #selector(loginFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //        emailInput.input.addTarget(self, action: #selector(emailFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    
    //    @objc func emailFieldDidChange(_ textField: UITextField) {
    //        print(textField.text)
    //    }
    //    @objc func loginFieldDidChange(_ textField: UITextField) {
    //        print(textField.text)
    //    }
}


