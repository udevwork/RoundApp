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
    private let refreshControl = UIRefreshControl()
    
    var card : CardView? = nil
    
    
    override init(viewModel: PostViewModel) {
        super.init(viewModel: viewModel)
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        transitioningDelegate = self
        self.card = viewModel.cardView
        
        
        setupTableView()
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
        header.setupDesign(viewModel)
    }
    
    fileprivate func setupDesign(){
        guard let header = header else { return }
        
        view.addSubview(table)
        header.backButton.setTarget {
            self.dismiss(animated: true) {
            }
        }
        header.onAvatarPress = { [weak self] in
            self?.routeToProfile()
        }
        header.saveToBookmark.setTarget { [weak self] in
            self?.onBookmarkPress()
        }
        table.easy.layout(Edges())
        
    }
    
    private func setupTableView(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.sectionFooterHeight = 0
        table.tableFooterView = nil
        table.rowHeight = UITableView.automaticDimension
        table.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = .clear
        refreshControl.attributedTitle = NSAttributedString(string: "close", attributes: nil)
        if #available(iOS 11.0, *) {
            table.insetsContentViewsToSafeArea = true;
            table.contentInsetAdjustmentBehavior = .never
        }
        table.register(TitlePostCellView.self, forCellReuseIdentifier: "TitlePostCellView")
        table.register(ArticlePostCellView.self, forCellReuseIdentifier: "ArticlePostCellView")
        table.register(SimplePhotoPostCellView.self, forCellReuseIdentifier: "SimplePhotoPostCellView")
    }
    
    private func routeToProfile(){
        let vc = ProfileRouter.assembly(userId: (viewModel.cardView.viewModel?.author?.uid)!)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func onBookmarkPress(){
        print("bookmark", "press")
        
        if header!.isSubscribed { // remoove
            print("bookmark 1", header!.isSubscribed)
            FirebaseAPI.shared.removeBookmark(postId: viewModel.cardView.viewModel!.id) { [weak self] result in
                guard let self = self else {return}
                if result == .success {
                    self.header!.saveToBookmark.setIcon(Icons.bookmark)
                    self.header!.isSubscribed = false
                    AccountManager.shared.data.bookmarks.removeAll { bid -> Bool in
                        if bid == self.viewModel.cardView.viewModel!.id {
                            print("bookmark", "remove, ",bid)
                            return true
                        } else {
                            return false
                        }
                    }
                    
                }
            }
            
        } else { // add
            print("bookmark 2", header!.isSubscribed)
            FirebaseAPI.shared.saveBookmark(postId: viewModel.cardView.viewModel!.id) { [weak self] result in
                guard let self = self else {return}
                if result == .success {
                    self.header!.saveToBookmark.setIcon(Icons.bookmarkfill)
                    self.header!.isSubscribed = true
                    AccountManager.shared.data.bookmarks.append(self.viewModel.cardView.viewModel!.id)
                    print("bookmark", "add, ",self.viewModel.cardView.viewModel!.id)
                    
                }
            }
        }
        
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.dismiss(animated: true)
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

