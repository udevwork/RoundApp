//
//  PostBlockSelectorViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 12.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostBlockSelectorModel {
    
    
    let onBlockSelect: (PostBlockSelectorModel.Types)->()
    enum Types {
        case simpleText(model: PostBlockSelectorViewCellModel)
        case TitleText(model: PostBlockSelectorViewCellModel)
        case Photo(model: PostBlockSelectorViewCellModel)
        case Fake(model: PostBlockSelectorViewCellModel)
    }
    var cells : [[Types]] = [[],[]]
    init(onBlockSelect: @escaping (PostBlockSelectorModel.Types)->()) {
        self.onBlockSelect = onBlockSelect
        cells[0].append(.TitleText(model: PostBlockSelectorViewCellModel("Title", "The name of a book, composition, or other artistic work.", UIImage(systemName: "textformat.alt")!,false)))
        cells[0].append(.simpleText(model: PostBlockSelectorViewCellModel("Text", "a piece of writing included with others", UIImage(systemName: "textformat.abc")!,false)))
        cells[0].append(.Photo(model: PostBlockSelectorViewCellModel("Photo", "square picture. Screen Width", UIImage(systemName: "photo")!,false)))
        
        /// FAKE CELLS
        
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Video", "upload you video file", UIImage(systemName: "play.rectangle.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Audio", "embed you sound", UIImage(systemName: "play.fill")!,true)))
        
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Map", "locate yourself or othet point", UIImage(systemName: "map.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Link", "link to your website", UIImage(systemName: "link.circle.fill")!,true)))
        
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Bag", "insert to cell", UIImage(systemName: "bag.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Creditcard", "grab donats directly", UIImage(systemName: "creditcard.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("File", "download file", UIImage(systemName: "arrow.down.doc.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Calendar", "use this to show special date", UIImage(systemName: "calendar")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Grid gallery", "square grid gallery", UIImage(systemName: "square.grid.2x2.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Like", "simple like counter", UIImage(systemName: "hand.thumbsup.fill")!,true)))
        cells[1].append(.Fake(model: PostBlockSelectorViewCellModel("Dislike", "dislike counter", UIImage(systemName: "hand.thumbsdown.fill")!,true)))
    }
}

class PostBlockSelectorViewController: BaseViewController<PostBlockSelectorModel> {
    
    let onBlockSelect: (PostBlockSelectorModel.Types)->()
  
    
    let table = UITableView(frame: .zero, style: .plain)
    
    override init(viewModel: PostBlockSelectorModel) {
        onBlockSelect = viewModel.onBlockSelect
        super.init(viewModel: viewModel)
        view.addSubview(table)
        view.backgroundColor = .systemGray5
        table.backgroundColor = .systemGray5
        table.separatorStyle = .none
        table.easy.layout(Edges())
        table.delegate = self
        table.dataSource = self
        table.register(PostBlockSelectorViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostBlockSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.cells[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostBlockSelectorViewCell
                
        switch data {
            case let .simpleText(model):
                cell.setupWith(model: model)
            case let .TitleText(model):
                cell.setupWith(model: model)
            case let .Photo(model):
                cell.setupWith(model: model)
            case let .Fake(model):
                cell.setupWith(model: model)
            }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.cells[indexPath.section][indexPath.row]
        if indexPath.row > 2 {return}
        onBlockSelect(data)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: PostBlockSelectorTableViewHeaderView = PostBlockSelectorTableViewHeaderView(frame: .zero)
        switch section {
        case 0:
            header.headerTitle.text = "Avalable blocks"
        case 1:
            header.headerTitle.text = "Premium"
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

