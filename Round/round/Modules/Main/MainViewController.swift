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

    fileprivate var filterView : FilterSlider = FilterSlider()
    var postViewer : CardsViewer = CardsViewer()
    let createButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 50)))
        .setStyle(.text)
        .setText("Create")
        .setTextColor(.white)
        .setCornerRadius(13)
        .setTarget { print("open") }
        .build()
    
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        title = "Round"
        setupViewe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViewe(){
        view.addSubview(postViewer)
        view.addSubview(filterView)
        view.addSubview(createButton)
        filterView.easy.layout(
            Height(50), Top(80), Trailing(), Leading()
        )
        filterView.setup()
        
        postViewer.delegate = self
        postViewer.easy.layout(
            Leading(20),Trailing(50),Top(20).to(filterView),Bottom(30).to(createButton)
        )
        createButton.easy.layout(
           Bottom(30),Trailing(50)
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
