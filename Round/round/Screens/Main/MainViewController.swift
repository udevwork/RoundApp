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
    
    
    // MARK: - Constants
    
    let cellWidth =   UIScreen.main.bounds.width
    let cellHeight =  UIScreen.main.bounds.height - 200

    // MARK: - UI Components
   
    fileprivate lazy var postCollectionView : GeminiCollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
    
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.numberOfItemsPerPage = 1
        layout.velocityThresholdPerPage = 10
        
        let collection = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        return collection
    }()
    
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        title = "Round"
        setUpMenuButton()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
 
    
    func setUpMenuButton(){
       // navigationItem.largeTitleDisplayMode = .never
        let item = UIBarButtonItem(image: Icons.user.image(), landscapeImagePhone: Icons.user.image(), style: .plain, target: self, action: #selector(user))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func user() {

    }
   
   
    fileprivate func setupView(){
        
        view.addSubview(postCollectionView)
        let bottom = Design.safeArea.bottom + 150
        let top = Design.safeArea.top + 100
        postCollectionView.easy.layout(Trailing(),Leading(),Bottom(bottom),Top(top))
        postCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        //postCollectionView.easy.layout( Edges() )
        
        postCollectionView.gemini
            .customAnimation()
            .alpha(0.2)
            .scale(x: 0.8, y: 0.8, z: 1)
            .rotationAngle(x: 0, y: 6, z: 0)
                
        viewModel.loadNewPost {
            DispatchQueue.main.async { [weak self] in
                self?.postCollectionView.reloadData()
            }
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
        cell.card.onCardPress = { [weak self] view, model in
            let postVC = PostViewController(viewModel: PostViewModel(cardView: view))
            postVC.modalPresentationStyle = .custom
            self?.present(postVC, animated: true, completion: nil)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        postCollectionView.animateVisibleCells()
    }

}

class CustomCell: GeminiCell {
    let card : CardView = CardView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(card)
        card.easy.layout(Leading(25),Trailing(25),Top(),Bottom())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(_ model: CardViewModel){
        card.setupData(model)
    }
}
