//
//  PostEdtorViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 09.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostEdtorViewController: BaseViewController<PostEditorViewModel> {
    let indicator = LoadingIndicator()
    private lazy var blocksTableView: UITableView = UITableView(frame: .zero, style: .plain)
    deinit {
        viewModel.needToUpdateTable.removeObserver(self)
        print("EDITOR DEINIT")
    }
    override init(viewModel: PostEditorViewModel) {
        super.init(viewModel: viewModel)
        observeKeyboardNotifications()
        title = "Create post"
        viewModel.needToUpdateTable.observe(self) { [weak self]  _, _ in
            self?.blocksTableView.reloadData()
        }
        viewModel.cellSizeChange.observe(self) { [weak self]  _, _ in
            DispatchQueue.main.async {
                self?.blocksTableView.beginUpdates()
                self?.blocksTableView.endUpdates()
            }
        }
        setupView()
    }
    
    func setUpSaveButton(){
        
        let b : Button = ButtonBuilder()
            .setFrame(CGRect(origin: .zero, size: .zero))
            .setStyle(.text)
            .setText("Save")
            .setTextColor(.white)
            .setColor(.systemIndigo)
            .setCornerRadius(13)
            .setTarget {
                self.save()
        }
        .build()
        
        
        let menuBarItem = UIBarButtonItem(customView: b)
        self.navigationItem.rightBarButtonItem = menuBarItem
        navigationController?.navigationBar.barTintColor  = UIColor.systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(blocksTableView)
        view.addSubview(indicator)
        indicator.easy.layout(Edges())
        setUpSaveButton()
        blocksTableView.easy.layout(Edges())
        setupTable()
    }
    
    private func setupTable() {
        blocksTableView.allowsSelection = false
        blocksTableView.backgroundColor = UIColor.systemGray6
        blocksTableView.contentInsetAdjustmentBehavior = .never
        blocksTableView.delegate = self
        blocksTableView.dataSource = self
        blocksTableView.separatorStyle = .none
        blocksTableView.rowHeight = UITableView.automaticDimension
        blocksTableView.register(PostEditorHeaderCell.self, forCellReuseIdentifier: "PostEditorHeaderCell")
        blocksTableView.register(PostEditorAddNewBlockCell.self, forCellReuseIdentifier: "PostEditorAddNewBlockCell")
        blocksTableView.register(PostEditorSimpleTextCell.self, forCellReuseIdentifier: "PostEditorSimpleTextCell")
blocksTableView.register(PostEditorTitleTextCell.self, forCellReuseIdentifier: "PostEditorTitleTextCell")
        
    
    }
    
    func save(){
        indicator.showActivityIndicatory()
        FirebaseAPI.shared.savePost(cellData: viewModel.dataSource) { [weak self] in
            self?.indicator.hideActivityIndicatory()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}



extension PostEdtorViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = viewModel.dataSource[indexPath.row]
        switch data {
        case let .header(model):
            let cell : PostEditorHeaderCell = PostEditorHeaderCell()
            cell.setupWith(model: model)
            return cell
        case let .addButton(model):
            let cell : PostEditorAddNewBlockCell = PostEditorAddNewBlockCell()
            cell.setupWith(model: model)
            return cell
        case let .simpleText(model):
            let cell : PostEditorSimpleTextCell = PostEditorSimpleTextCell()
            cell.setupWith(model: model)
            return cell
        case .photo(let model):
            let cell : PostEditorPhotoBlockCell = PostEditorPhotoBlockCell()
            cell.setupWith(model: model)
            return cell
        case .title(let model):
            let cell : PostEditorTitleTextCell = PostEditorTitleTextCell()
            cell.setupWith(model: model)
            return cell
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //Adding observer to keyboard notifications
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    @objc func keyboardShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.3) {
                self.blocksTableView.easy.layout(Bottom(keyboardHeight))
                self.view.layoutSubviews()
            }
           
           }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.blocksTableView.easy.layout(Bottom(0))
            self.view.layoutSubviews()
        }
    }
    
    
}
