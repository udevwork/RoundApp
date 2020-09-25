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
    let cellHeight =  UIScreen.main.bounds.height - 100

    let sectionSpacing: CGFloat = 0
    let cellSpacing: CGFloat = 0
    
    // MARK: - UI Components
   
    fileprivate lazy var postCollectionView : GeminiCollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: 0, bottom: 0, right: 0)
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
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        let bottom = Design.safeArea.bottom + 150
        let top = Design.safeArea.top + 10
        postCollectionView.easy.layout(Trailing(),Leading(),Bottom(),Top() )

    }
    
    func setUpMenuButton(){
        navigationItem.largeTitleDisplayMode = .never
        let item = UIBarButtonItem(image: Icons.user.image(), landscapeImagePhone: Icons.user.image(), style: .plain, target: self, action: #selector(user))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc func user() {

    }
   
   
    fileprivate func setupView(){
        
        view.addSubview(postCollectionView)
        postCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        //postCollectionView.easy.layout( Edges() )
        
        postCollectionView.gemini
            .customAnimation()
            .alpha(0.2)
            .scale(x: 0.8, y: 0.8, z: 1)
            .rotationAngle(x: 0, y: 6, z: 0)
                
        viewModel.loadNewPost { _ in 
            DispatchQueue.main.async { [weak self] in
                self?.postCollectionView.reloadData()
              //  self?.postCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .top, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.cards.count - 2 {
            viewModel.loadNewPost { inserIndexPaths in
                DispatchQueue.main.async { [weak self] in
        
                    //self?.postCollectionView.reloadData()
                    self?.postCollectionView.insertItems(at: inserIndexPaths)
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
        card.easy.layout(Leading(25),Trailing(25),Top(0),Bottom(120 + Design.safeArea.bottom))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(_ model: CardViewModel){
        card.setupData(model)
    }
    
}
