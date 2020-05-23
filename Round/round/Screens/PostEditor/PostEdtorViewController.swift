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
    
    private lazy var blocksTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var toolKit: UIVisualEffectView = {
        let blure : UIBlurEffect = UIBlurEffect(style: .prominent)
        let blureview: UIVisualEffectView = UIVisualEffectView(effect: blure)
        return blureview
    }()
    private lazy var toolKitStask: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    
    /// ToolKit Buttons
    let addBlocks : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.addPostBlock)
        .build()
    let locationBlocks : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.systemGray3)
        .setColor(.clear)
        .setIcon(.pin)
        .build()
    let deleteBlocks : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.trash)
        .build()
    let saveBlocks : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        .setStyle(.icon)
        .setIconSize(CGSize(width: 25, height: 25))
        .setIconColor(.label)
        .setColor(.clear)
        .setIcon(.arrowShare)
        .build()
    
    override init(viewModel: PostEditorViewModel) {
        super.init(viewModel: viewModel)
        observeKeyboardNotifications()
        title = "Create post"
        viewModel.needToUpdateTable.observe(self) { [weak self]  _, _ in
            self?.blocksTableView.reloadData()
            let lastRow = (self?.viewModel.dataSource.count)! - 1
            self?.blocksTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
        }
        viewModel.cellSizeChange.observe(self) { [weak self]  _, _ in
            DispatchQueue.main.async {
                self?.blocksTableView.beginUpdates()
                self?.blocksTableView.endUpdates()
            }
        }
        setupView()
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(blocksTableView)
        view.addSubview(toolKit)
        view.addSubview(toolKitStask)
        
        blocksTableView.easy.layout(Edges())
        toolKit.easy.layout(Leading(),Trailing(),Height(40),Bottom())
        toolKitStask.easy.layout(Leading(),Trailing(),Height(40),Bottom())
        setupTable()
        setupToolKit()
        
        saveBlocks.setTarget { [weak self] in
            self?.save()
        }
        
        locationBlocks.setTarget { [weak self] in
            self?.viewModel.getLocation() { [weak self] in
                self?.locationBlocks.setIconColor(.systemTeal)
            }
        }
    }
    
    private func setupTable() {
        blocksTableView.allowsSelection = true
        blocksTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
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
    
    private func setupToolKit() {
        toolKitStask.addArrangedSubview(addBlocks)
        toolKitStask.addArrangedSubview(locationBlocks)
        toolKitStask.addArrangedSubview(deleteBlocks)
        toolKitStask.addArrangedSubview(saveBlocks)
        
        addBlocks.setTarget { [weak self] in
            self?.viewModel.showBlockPicker()
        }
        deleteBlocks.setTarget { [weak self] in
            self?.blocksTableView.isEditing = !(self?.blocksTableView.isEditing)!
            if (self?.blocksTableView.isEditing)! {
                self?.deleteBlocks.setIcon(.trashCross)
                self?.deleteBlocks.setIconColor(.systemRed)
            } else {
                self?.deleteBlocks.setIcon(.trash)
                self?.deleteBlocks.setIconColor(.label)
            }
        }
    }
    
    func save(){
        viewModel.save()
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
            cell.deleteButton.setTarget { [weak self] in
                let index = (self?.blocksTableView.indexPath(for: cell))!
                self?.viewModel.dataSource.remove(at: index.row)
                self?.blocksTableView.deleteRows(at: [index], with: .fade)
            }
            return cell
        case .photo(let model):
            let cell : PostEditorPhotoBlockCell = PostEditorPhotoBlockCell()
            cell.setupWith(model: model)
            cell.deleteButton.setTarget { [weak self] in
                let index = (self?.blocksTableView.indexPath(for: cell))!
                self?.viewModel.dataSource.remove(at: index.row)
                self?.blocksTableView.deleteRows(at: [index], with: .fade)
            }
            return cell
        case .title(let model):
            let cell : PostEditorTitleTextCell = PostEditorTitleTextCell()
            cell.setupWith(model: model)
            cell.deleteButton.setTarget { [weak self] in
                let index = (self?.blocksTableView.indexPath(for: cell))!
                self?.viewModel.dataSource.remove(at: index.row)
                self?.blocksTableView.deleteRows(at: [index], with: .fade)
            }
            return cell
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(destinationIndexPath.row)
        if destinationIndexPath.row != 0 {
            let item = viewModel.dataSource[sourceIndexPath.row]
            viewModel.dataSource.remove(at: sourceIndexPath.row)
            viewModel.dataSource.insert(item, at: destinationIndexPath.row)
        } else {
            tableView.moveRow(at: destinationIndexPath, to: sourceIndexPath)
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0{
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
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


