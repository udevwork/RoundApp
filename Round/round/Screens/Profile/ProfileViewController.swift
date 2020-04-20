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
    let userAvatar : UserAvatarView = UserAvatarView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let userNameLabel : Text = Text(.article,  .label)
//    let nameeInput: InputField = InputField(icon: Icons.edit, placeHolder: "username")
    
    let stack : UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.axis = .horizontal
        s.distribution = .equalCentering
        s.spacing = 20
        return s
    }()
    
    let postCount: Text = Text(.article, .tertiaryLabel, .zero)
    let subsCount: Text = Text(.article, .tertiaryLabel, .zero)
    
    
//    let saveUserInfoButton : Button = ButtonBuilder()
//    .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
//    .setStyle(.text)
//    .setText("save info")
//    .setTextColor(.white)
//    .setCornerRadius(13)
//    .build()
    
    let postCollection : UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let c = UICollectionView(frame: .zero, collectionViewLayout: flow)
        return c
    }()
    
    override init(viewModel: ProfileViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Profile"
    
        viewModel.loadUserInfo()
        viewModel.loadUserPostsList()
        setupView()
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = AccountManager.shared.data.user else { return }
        print("CURRENT ID: ",AccountManager.shared.data.uid)
        if AccountManager.shared.data.anonymous {
            print("Anonymus")
        } else {
            print("USER NAME: ",user.userName as Any)
        }
    }
    
    private func setupView() {
        setUpMenuButton()
        [userAvatar,userNameLabel,stack, postCollection].forEach {
            view.addSubview($0)
        }
        userAvatar.easy.layout(Top(40),CenterX(),Width(100),Height(100))
        userNameLabel.easy.layout(Leading(10).to(userAvatar,.trailing),CenterY().to(userAvatar))
        userNameLabel.sizeToFit()
        stack.easy.layout(Leading(30),Trailing(30),Height(21), Top(20).to(userAvatar,.bottom))
        postCount.text = "posts createed 12"
        subsCount.text = "subscriders 2"

        stack.addArrangedSubview(postCount)
        stack.addArrangedSubview(subsCount)
        
        
        postCollection.easy.layout(Leading(10), Trailing(10),Bottom(20),Top(20).to(stack))
        postCollection.register(ProfilePostCell.self, forCellWithReuseIdentifier: "ProfilePostCell")
        postCollection.delegate = self
        postCollection.dataSource = self
        postCollection.backgroundColor = .systemGray6


//        saveUserInfoButton.setTarget {
//            print("saveUserInfoButton")
//            AccountManager.shared.network.saveUserName(newName: self.nameeInput.input.text!)
//        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(photoLibrary))
        userAvatar.addGestureRecognizer(tap)
    }
    
    private func setupUserinfoView(){
        guard let user = viewModel.user else {
            return
        }
        
        if user.uid == AccountManager.shared.data.uid { // SELF ACCOUNT
            
        }
        
        if AccountManager.shared.data.anonymous {
            userAvatar.setImage("avatarPlaceholder")
            userNameLabel.text = "anonymous"
        } else {
            if let url = user.photoUrl, let imageUrl = URL(string: url) {
                userAvatar.setImage(imageUrl)
            } else {
                userAvatar.setImage("avatarPlaceholder")
            }
            userNameLabel.text = user.userName
        }
        
    }
    
    func setUpMenuButton(){
        
        let b : Button = ButtonBuilder()
            .setFrame(CGRect(origin: .zero, size: .zero))
            .setStyle(.icon)
            .setIcon(Icons.edit.image())
            .setIconColor(.systemRed)
            .setColor(.clear)
            .setTarget {
                print("SignInButton")
                let vc = SignInRouter.assembly(model: SignInViewModel())
                self.navigationController?.pushViewController(vc, animated: true)
        }
        .build()
        
        
        let menuBarItem = UIBarButtonItem(customView: b)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    private func setupObserver(){
        viewModel.postDataUpdated.observe(self) { [weak self] _, _ in
            self?.postCollection.reloadData()
        }
        viewModel.userInfoUpdated.observe(self) { [weak self] _,_ in
            self?.setupUserinfoView()
        }
    }
    
    var photoPicker: UIImagePickerController?
    @objc func photoLibrary(){
       let vc = ImagePicker { [weak self] image in
        self?.userAvatar.setImage(image)
        self?.saveImage()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func saveImage(){
        guard let imageToUpload = userAvatar.image else {return}
        Network().uploadImage(uiImage: imageToUpload) { result in
            print("OK")
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.postsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = viewModel.postsData else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePostCell", for: indexPath) as! ProfilePostCell
        cell.setup(model: data[indexPath.row])
        cell.card.onCardPress = { [weak self] view, model in
            let vc = PostViewController(viewModel: PostViewModel(cardView: view))
            self?.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height - 30, height: collectionView.frame.height - 5)
    }
}


class ProfilePostCell: UICollectionViewCell {
    let card = CardView(viewModel: nil, frame: .zero )
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(card)
        card.easy.layout(Edges(5))
        card.transparent = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setup(model: CardViewModel){
        card.setupData(model)
    }
}
