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

class MainViewController: BaseViewController<MainViewModel> {
    
    fileprivate var postViewer : CardsViewer = CardsViewer()
    fileprivate var filterView : ScrollStack = ScrollStack()
    
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        title = "Round"
        controllerIcon = Icons.location
        setupViewe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViewe(){
        view.addSubview(postViewer)
        view.addSubview(filterView)
        filterView.easy.layout(
            Height(50), Top(80), Trailing(), Leading()
        )
        filterView.setup()
        
        postViewer.delegate = self
        postViewer.easy.layout(
            CenterX(),CenterY(),Height(200),Width(200)
        )
        viewModel.loadCards {
            DispatchQueue.main.async {
                self.postViewer.reloadCards()
            }
        }
    }
    
}

extension MainViewController : PostViewerDelegate {
    func postViewer(selectedCard: CardView) {
        let vc = PostViewController(viewModel: PostViewModel(cardView: selectedCard))
        self.present(vc, animated: true, completion: nil)
    }
    
    func postViewerGetNextCard() -> CardViewModel {
        guard let card = viewModel.getNextCard() else {return CardViewModel(id: "no id", mainImageURL: nil, title: nil, description: nil, viewsCount: nil, author: nil) }
        return card
    }
    
    func postViewer(currentCard: CardViewModel) {
        
    }
    
    func postViewer(loadedCardsCount: Int) {
        
    }
    
}
