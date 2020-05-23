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
    let emptyPostlabel: Text = Text(.article, .systemGray3, .zero)
    var animation: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut, animations: nil)
    var isSelfProfile: Bool = false
    enum State {
        case Collapsed
        case Expanded
    }
    
    var state: State = .Expanded
    
    let header: ProfileViewControllerHeader = ProfileViewControllerHeader()
    
    let postCollection : UICollectionView = {
        let flow = ProfileCollectionLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 20
        flow.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        let c = UICollectionView(frame: .zero, collectionViewLayout: flow)
        return c
    }()
    
    override init(viewModel: ProfileViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Author" // Profile
    
        viewModel.loadUserInfo()
        setupView()
        setupObserver()
        setUpLogoutButton()
        if viewModel.userId == AccountManager.shared.data.uid {
            isSelfProfile = true
        }
    }
    
    deinit {
        print("ProfileViewController DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let user = AccountManager.shared.data.user else { return }
        Debug.log("CURRENT ID: ",AccountManager.shared.data.uid)
        if AccountManager.shared.data.anonymous {
            Debug.log("Anonymus")
        } else {
            Debug.log("USER NAME: ",user.userName as Any)
        }
    }
    
    
    func setUpLogoutButton() {
        
        let b : Button = ButtonBuilder()
            .setFrame(CGRect(origin: .zero, size: .zero))
            .setStyle(.icon)
            .setIcon(UIImage(named: "logout")!)
            .setIconColor(.label)
            .setColor(.clear)
            .setTarget { [weak self] in
                self?.viewModel.logout {
                    self?.navigationController?.popViewController(animated: true)
                }
        }
        .build()
        
        let menuBarItem = UIBarButtonItem(customView: b)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    private func setupView() {
        view.addSubview(postCollection)
        view.addSubview(header)

        header.easy.layout(Leading(), Trailing(),Height(300),Top())
        postCollection.register(ProfileViewControllerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfilePostHeader")
        postCollection.easy.layout(Leading(10), Trailing(10),Bottom(),Top().to(header))
        postCollection.register(ProfilePostCell.self, forCellWithReuseIdentifier: "ProfilePostCell")
        postCollection.delegate = self
        postCollection.dataSource = self
        postCollection.backgroundColor = .systemGray6
        postCollection.showsVerticalScrollIndicator = false
        postCollection.showsHorizontalScrollIndicator = false
        postCollection.layer.masksToBounds = false
       
        animation.isUserInteractionEnabled = true
        animation.isManualHitTestingEnabled = true
        
        header.bookmarks.setTarget { [weak self] in
            self?.viewModel.navigateToBookmarks()
        }
        header.editProfile.setTarget { [weak self] in
            self?.viewModel.navigateToProfileEditor()
        }
        header.addPost.setTarget { [weak self] in
            self?.viewModel.navigatePostEditor()
        }
    }

    
    private func setupObserver(){
        viewModel.postDataUpdated.observe(self) { [weak self] in
            self?.setupUserPosts()
        }
        
        viewModel.userInfoUpdated.observe(self) { [weak self] in
            self?.setupAvatar()
        }
    }    
    
   private func setupAvatar() {
        header.userNameLabel.text = viewModel.userName
        if viewModel.userAvatar == nil {
            if let url = viewModel.userAvaratURL {
                header.userAvatar.setImage(url)
                viewModel.userAvatar = header.userAvatar.image
            } else {
                header.userAvatar.setImage(UIImage(named: "avatarPlaceholder")!)
            }
        } else {
            header.userAvatar.setImage(viewModel.userAvatar!)
        }
        
        if isSelfProfile {
            header.setupStackMenu()
        }
    }
    
   private func setupUserPosts(){
        postCollection.reloadData()
        if let count =  viewModel.postsData?.count {
            header.postCount.text = "post created \(count)"
            if count == 0 {
                postCollection.addSubview(emptyPostlabel)
                emptyPostlabel.easy.layout(CenterY(),CenterX())
                emptyPostlabel.text = "no posts created"
            } else {
                emptyPostlabel.removeFromSuperview()
            }
        }
    }
    
   private func expandAnimation() {
        animation.addAnimations { [weak self] in
            self?.header.easy.layout(Height(300))
            self?.view.layoutSubviews()
        }
        animation.addCompletion { s in
            if s == .end {
                self.state = .Expanded
            }
        }
        animation.startAnimation()
    }
    
   private func collapseAnimation() {
        animation.addAnimations { [weak self] in
            self?.header.easy.layout(Height(70))
            self?.view.layoutSubviews()
        }
        animation.addCompletion { s in
            if s == .end {
                self.state = .Collapsed
            }
        }
        animation.startAnimation()
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
        cell.setup(model: data[indexPath.row],showAuthor: false)
        cell.card.onCardPress = { [weak self] view, model in
            let vc = PostViewController(viewModel: PostViewModel(cardView: view))
            vc.modalPresentationStyle = .pageSheet
            self?.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.state == .Expanded {
            if scrollView.contentOffset.y > 20 {
                collapseAnimation()
                header.collapseAnimation()
            }
        } else {
            if scrollView.contentOffset.y < 20 {
                expandAnimation()
                header.expandAnimation()
            }
        }
    }
    
    
}

