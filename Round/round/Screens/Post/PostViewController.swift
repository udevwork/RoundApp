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
    var animatableHeader : PostViewControllerHeader? = nil
    
    var table : UITableView = UITableView(frame: .zero, style: .grouped)
    let animation = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8, animations: nil)
    
    var card : CardView? = nil
    
    
    override init(viewModel: PostViewModel) {
        super.init(viewModel: viewModel)
        modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .white
        transitioningDelegate = self
        self.card = viewModel.cardView
        
        
        setupTableView()
        header = PostViewControllerHeader(frame: view.bounds, viewModel: viewModel.cardView.viewModel!, card: card!)
        animatableHeader = PostViewControllerHeader(frame: view.bounds, viewModel: viewModel.cardView.viewModel!, card: card!)
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
        header.backButton.addTarget {
            self.dismiss(animated: true) { }
        }
        
        table.easy.layout(Edges())
        let gesture: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(closeGesture))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
    
    func setupHeaderAnimation() {
        animation.addAnimations { [weak self] in
            self?.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self?.view.layer.cornerRadius = 50
            if self!.useAnimatableHeader == true {
                self?.animatableHeader?.frame.origin = .zero
            }
        }
    }
    
    var contentOffset: CGPoint = .zero
    var useAnimatableHeader: Bool = false
    @objc func closeGesture(sender : UIScreenEdgePanGestureRecognizer){
        switch sender.state {
        case .began:
            beganCloseAnimation()
            break
        case .changed:
            closeAnimation(x: sender.location(in: self.view).x)
            break
        default:
            endCloseAnimation(x: sender.location(in: self.view).x)
            break
        }
    }
    //act inac stop
    func beganCloseAnimation() {
        setupHeaderAnimation()
        contentOffset = table.contentOffset
        if contentOffset.y >= header!.frame.height {
            view.addSubview(animatableHeader!)
            animatableHeader?.frame.origin = CGPoint(x: 0, y: -animatableHeader!.frame.height)
            useAnimatableHeader = true
        }
        animation.startAnimation()
        animation.pauseAnimation()
    }
    
    func closeAnimation(x: CGFloat) {
        let val = x/100
        if val >= 1 {
            animation.addCompletion { [weak self] position in
                self?.dismiss(animated: true)
            }
            animation.startAnimation()
            table.setContentOffset(.zero, animated: true)
            
        }
        animation.fractionComplete = val
        if useAnimatableHeader == false {
            table.contentOffset = CGPoint(x: 0, y: (contentOffset.y * normalizeInvert(val: x)))
        }
    }
    
    func endCloseAnimation(x: CGFloat){
        let val = x/100
        if val < 1 {
            animation.isReversed = true
            table.setContentOffset(contentOffset, animated: true)
            animation.addCompletion { [weak self] _ in
                self?.useAnimatableHeader = false
            }
        } else {
            table.setContentOffset(.zero, animated: true)
        }
        animation.startAnimation()
    }
    
    private func normalize(val : CGFloat) -> CGFloat{
        if val < 0 {
            return 0
        }
        if val > 100 {
            return 1
        }
        return (val - 0) / (100 - 0)
    }
    
    private func normalizeInvert(val : CGFloat) -> CGFloat{
        if val < 0 {
            return 1
        }
        if val > 100 {
            return 0
        }
        return (val - 100) / (0 - 100)
    }
    
    
    private func setupTableView(){
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.sectionFooterHeight = 0
        table.tableFooterView = nil
        table.rowHeight = UITableView.automaticDimension
        table.allowsSelection = false
        
        if #available(iOS 11.0, *) {
            table.insetsContentViewsToSafeArea = true;
            table.contentInsetAdjustmentBehavior = .never
        }
        
        table.register(TitlePostCellView.self, forCellReuseIdentifier: "TitlePostCellView")
        table.register(ArticlePostCellView.self, forCellReuseIdentifier: "ArticlePostCellView")
        table.register(SimplePhotoPostCellView.self, forCellReuseIdentifier: "SimplePhotoPostCellView")
        table.register(GalleryPostCellView.self, forCellReuseIdentifier: "GalleryPostCellView")
        table.register(DownloadPostCellView.self, forCellReuseIdentifier: "DownloadPostCellView")

    }
    
    
    
    
    private func showDeleteSuccsessAlert(){
        let action = UIAlertController(title: "Delete cemplete", message: nil, preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { action in
            
        }))
        
        self.present(action, animated: true) {
            
        }
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
    enum cellTypeSeqence {
        case next, previous
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postBlocks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : BasePostCellProtocol?
        let model = viewModel.postBlocks[indexPath.row]
        var padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        switch model.type {
        case .Title:
            cell = tableView.dequeueReusableCell(withIdentifier: "TitlePostCellView", for: indexPath) as! TitlePostCellView
            
            if let t = cellType(of: .previous, currentIndexPathRow: indexPath.row), t == .Article {
                padding.top = 5
            }
            if let t = cellType(of: .next, currentIndexPathRow: indexPath.row), t == .Article {
                padding.bottom = 5
            }
            if let t = cellType(of: .previous, currentIndexPathRow: indexPath.row), t == .Title {
                padding.top = 10
            }
            if let t = cellType(of: .next, currentIndexPathRow: indexPath.row), t == .Title {
                padding.bottom = 10
            }
            
        case .Article:
            cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePostCellView", for: indexPath) as! ArticlePostCellView
            
            if let t = cellType(of: .previous, currentIndexPathRow: indexPath.row), t == .Article {
                padding.top = 1.5
            }
            if let t = cellType(of: .next, currentIndexPathRow: indexPath.row), t == .Article {
                padding.bottom = 1.5
            }
        case .SimplePhoto:
            cell = tableView.dequeueReusableCell(withIdentifier: "SimplePhotoPostCellView", for: indexPath) as! SimplePhotoPostCellView
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .Gallery:
            cell = tableView.dequeueReusableCell(withIdentifier: "GalleryPostCellView", for: indexPath) as! GalleryPostCellView
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .Download:
            cell = tableView.dequeueReusableCell(withIdentifier: "DownloadPostCellView", for: indexPath) as! DownloadPostCellView
            (cell as! DownloadPostCellView).onDownloadPress = { link in
              //  let vc = DownloadViewController(link: link)
                //  self.present(vc, animated: true, completion: nil)
            }
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .none:
            break
        }
        cell?.setup(viewModel: model)
        cell?.setPadding(padding: padding)
        
        return cell ?? UITableViewCell()
    }
    
    func cellType(of seqence: cellTypeSeqence, currentIndexPathRow: Int) -> PostCellType? {
        let row: Int = seqence == .next ? currentIndexPathRow + 1 : currentIndexPathRow - 1
        if row > viewModel.postBlocks.count-1 || row < 0 {
            return nil
        } else {
            return viewModel.postBlocks[row].type
        }
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

