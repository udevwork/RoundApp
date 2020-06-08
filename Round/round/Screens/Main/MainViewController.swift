//
//  MainViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 07.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Gemini

class MainViewController: BaseViewController<MainViewModel> {
    
    fileprivate var filterView : FilterSlider = FilterSlider()
    
    var postCollectionView : GeminiCollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: UIScreen.main.bounds.height - 180)
        layout.numberOfItemsPerPage = 1
        layout.velocityThresholdPerPage = 10
        let collection = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
        collection.backgroundColor = .systemGray6
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        
        return collection
    }()
    
    let createButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.text)
        .setText("Create")
        .setTextColor(.white)
        .setCornerRadius(13)
        .build()
    
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        title = "Round"
        setUpMenuButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMenuButton(){
        
      
        let item = UIBarButtonItem(image: Icons.user.image(), landscapeImagePhone: Icons.user.image(), style: .plain, target: self, action: #selector(user))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func user() {
        if AccountManager.shared.data.anonymous {
            let model = SignInViewModel()
            let vc = SignInRouter.assembly(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProfileRouter.assembly(userId: AccountManager.shared.data.uid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
   
    func createPost() {
          let vc = PostEditorRouter.assembly()
          self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func setupView(){
        let lol = postCollectionView.collectionViewLayout as! PagingCollectionViewLayout
        let inset = (view.frame.width - 250)/2
        lol.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
        
        view.addSubview(postCollectionView)
        view.addSubview(filterView)
        view.addSubview(createButton)
        postCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        filterView.easy.layout (
            Height(30), Top(5), Trailing(), Leading()
        )
        filterView.setup()
        
        filterView.onAddFilterPress = { [weak self] in
            
            FirebaseAPI.shared.getCounties { (status, resp) in
                if status == .error { return }
                
                let map = resp?.Countries.map({ s -> CityViewModel in
                    return CityViewModel(cityName: s)
                })
                
                guard let model = map else { return }
                
                let filter = SearchViewController(viewModel: FilterViewModel(navigationTitle: "City", searchableModel: model, searchCellType: CityCell.self))
                
                filter.onCellPress = { [weak self] model in
                    self?.filterView.addTag(tagName: model.searchParameter)
                }
                
                self?.navigationController?.pushViewController(filter, animated: true)
            }
        }
        
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.easy.layout(
            Leading(),Trailing(),Top(20).to(filterView),Bottom(15).to(createButton)
        )
        
        
//        postCollectionView.gemini
//            .customAnimation()
////            .rotationAngle(x: 0, y: 20, z: 0)
////            .scaleEffect(.scaleUp)
////            .scale(x: 0.6, y: 0.6, z: 0.6)
//            .alpha(0.5)
        
        createButton.easy.layout(
            Bottom(15),Trailing(inset)
        )
        
        
        viewModel.loadNewPost { _ in 
            DispatchQueue.main.async { [weak self] in
                self?.postCollectionView.reloadData()
            }
        }
        
        createButton.setTarget {
            self.createPost()
        }
        
    }
    
    
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.setup(viewModel.cards[indexPath.row])
        cell.card.onCardPress = { view, model in
            let postVC = PostViewController(viewModel: PostViewModel(cardView: view))
            postVC.modalPresentationStyle = .overCurrentContext
            self.present(postVC, animated: true, completion: nil)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        postCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.cards.count - 2 {
            viewModel.loadNewPost { count in
                DispatchQueue.main.async { [weak self] in
                    var newIndexPath: [IndexPath] = []
                    for i in (self!.viewModel.cards.count-1)-(count-1)...(self!.viewModel.cards.count-1) {
                        newIndexPath.append(IndexPath(row: i, section: 0))
                    }
                    //self?.postCollectionView.reloadData()
                    self?.postCollectionView.insertItems(at: newIndexPath)
                }
            }
        }
        if let cell = cell as? GeminiCell {
            self.postCollectionView.animateCell(cell)
        }
    }
}

class CustomCell: GeminiCell {
    let card : CardView = CardView(viewModel: nil, frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(card)
        card.easy.layout(Edges())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(_ model: CardViewModel){
        card.setupData(model)
    }
    
}
