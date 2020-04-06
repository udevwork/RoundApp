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
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.text)
        .setText("Create")
        .setTextColor(.white)
        .setCornerRadius(13)
        .build()
    
    override init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Round"
        setUpMenuButton()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpMenuButton(){
        
        let b : Button = ButtonBuilder()
            .setFrame(CGRect(origin: .zero, size: .zero))
            .setStyle(.icon)
            .setIcon(Icons.user.rawValue)
            .setIconColor(.black)
            .setColor(.clear)
            .setTarget {
                self.user()
        }
            .build()
        
        
        let menuBarItem = UIBarButtonItem(customView: b)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
     func user() {
        
        let model = ProfileViewModel(user: AccountManager.shared.getCurrentUser())
        let vc = ProfileRouter.assembly(model: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func setupView(){
        view.addSubview(postViewer)
        view.addSubview(filterView)
        view.addSubview(createButton)
            
        filterView.easy.layout (
            Height(30), Top(50), Trailing(), Leading()
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
        
        postViewer.delegate = self
        postViewer.easy.layout(
            Leading(20),Trailing(50),Top(20).to(filterView),Bottom(15).to(createButton)
        )
        createButton.easy.layout(
           Bottom(15),Trailing(50)
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
