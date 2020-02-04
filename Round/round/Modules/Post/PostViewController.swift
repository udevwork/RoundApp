//
//  PostViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 23.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class PostViewController: BaseViewController<PostViewModel> {
    
    
    var header : PostViewControllerHeader? = nil
    var table : UITableView = UITableView(frame: .zero, style: .grouped)
    var card : CardView? = nil
    
    override init(viewModel: PostViewModel) {
        super.init(viewModel: viewModel)
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        transitioningDelegate = self
        self.card = viewModel.cardView
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.sectionFooterHeight = 0
        table.tableFooterView = nil
        table.rowHeight = UITableView.automaticDimension
        table.register(TitlePostCellView.self, forCellReuseIdentifier: "TitlePostCellView")
        table.register(ArticlePostCellView.self, forCellReuseIdentifier: "ArticlePostCellView")
        table.register(SimplePhotoPostCellView.self, forCellReuseIdentifier: "SimplePhotoPostCellView")
        header = PostViewControllerHeader(frame: view.bounds, viewModel: viewModel.cardView.viewModel!, card: card!)
        viewModel.loadPostBody {
            DispatchQueue.main.async {
                if self.viewModel.postBlocks.count > 0 {
                    self.table.reloadData()
                }
            }
        }
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ viewModel : CardViewModel){
        guard let header = header else { return }
        header.setupData(viewModel)
    }
    
    fileprivate func setupDesign(){
        guard let header = header else { return }
        view.addSubview(table)
        header.backButton.setTarget {
            // self.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.dismiss(animated: true) {
            }
        }
        table.easy.layout(Top(),Bottom(),Trailing(),Leading())
        
    }
}

extension PostViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PostOpenControllerAnimation(card: card!)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PostCloseControllerAnimation(header: header!, card: card!)
    }
}

extension PostViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postBlocks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : BasePostCellProtocol?
        let model = viewModel.postBlocks[indexPath.row]
        
        switch model.type {
        case .Title:
            cell = TitlePostCellView()
        case .Article:
            cell = ArticlePostCellView()
        case .SimplePhoto:
            cell = SimplePhotoPostCellView()
        case .none:
            break
        }
        cell?.setup(viewModel: model)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return header!} else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {return view.frame.height} else { return .zero }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
