//
//  BookmarksViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 20.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class BookmarksViewController: BaseViewController<BookmarksViewModel> {


    let table : UITableView = UITableView()
        
    override init(viewModel: BookmarksViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .always
        title = "Bookmarks"
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.keyboardDismissMode = .onDrag
        table.register(bookmarkCell.self, forCellReuseIdentifier: "bookmarkCell")
        view.addSubview(table)
        table.easy.layout(Top(5),Leading(20),Trailing(20), Bottom())
        viewModel.postDataUpdated.observe(self) {[weak self] _, _ in
            self?.table.reloadData()
        }
        viewModel.loadPosts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! bookmarkCell
        cell.setup(viewModel.postsData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: open post view controller
       //  let vc = PostViewController(viewModel: PostViewModel(cardView: viewModel.postsData[indexPath.row]))
       // self.present(vc, animated: true, completion: nil)
    }
    
}

class bookmarkCell : UITableViewCell {
    
    let bg: UIView = UIView()
    let userName: Text = Text(.article, .label, nil)
    let avatar: UIImageView = UIImageView()
    
    func setup(_ model: CardViewModel) {
        
        selectionStyle = .none
        
        addSubview(bg)
        bg.addSubview(userName)
        bg.addSubview(avatar)
        
        userName.text = model.title
        backgroundColor = .clear
        bg.backgroundColor = .systemGray4
        bg.layer.masksToBounds = true
        bg.layer.cornerRadius = 13
        
        if let url = URL(string: model.mainImageURL) {
            avatar.setImage(imageURL: url, placeholder: "ImagePlaceholder")
        }
        bg.easy.layout(Top(5),Bottom(5),Leading(),Trailing())
        avatar.easy.layout(CenterY(), Leading(10),Height(50), Width(50))
        userName.easy.layout(Top(),Bottom(),Leading(20).to(avatar),Trailing(20))
        avatar.layer.cornerRadius = 13
        avatar.layer.masksToBounds = true
    }
}

