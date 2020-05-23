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
    let editButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: .zero))
        .setStyle(.icon)
        .setIcon(.trash)
        .setIconColor(.systemRed)
        .setColor(.clear)
        .build()
    
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
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        view.addSubview(table)
        table.easy.layout(Top(5),Leading(20),Trailing(20), Bottom())
        viewModel.postDataUpdated.observe(self) {[weak self] _, _ in
            self?.table.reloadData()
        }
        viewModel.loadPosts()
        setUpMenuButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpMenuButton(){
        editButton.setTarget {
            self.edit(!self.table.isEditing)
        }
        let menuBarItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    func edit(_ isEditing: Bool) {
        if isEditing == true {
            table.isEditing = true
            editButton.setIcon(Icons.checkmark)
            editButton.setIconColor(.systemBlue)
        } else {
            table.isEditing = false
            editButton.setIcon(.trash)
            editButton.setIconColor(.systemRed)
        }
    }
    
}

extension BookmarksViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! bookmarkCell
        cell.setup(viewModel.postsData[indexPath.row])
        cell.card.onCardPress = { [weak self] view, model in
            let vc = PostViewController(viewModel: PostViewModel(cardView: view))
            self?.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            Debug.log(indexPath.row-1)
            viewModel.postsData.remove(at: indexPath.row-1)
            FirebaseAPI.shared.removeBookmark(post: viewModel.postsData[indexPath.row-1].id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

class bookmarkCell : UITableViewCell {
    
    var card: CardView = CardView(viewModel: nil, frame: .zero, showAuthor: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemGray6
        addSubview(card)
        card.easy.layout(Top(20),Bottom(20),Leading(20),Trailing(20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ model: CardViewModel) {
        card.setupData(model,showAuthor: true)
    }
}

