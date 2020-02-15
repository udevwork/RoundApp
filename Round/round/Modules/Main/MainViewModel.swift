//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    public let user : User = User(ID: 0, avatarImageURL: nil, userName: nil)
    public var cards : [CardViewModel] = []

    
    // load cards at first loading and as adding to present cards, pagination not needed
    func loadCards(_ complition : (()->())?)  {
        Network.fetchPosts { [weak self] cards in
            self?.cards.append(contentsOf: cards)
            complition?()
        }
    }
    
    func getNextCard() -> CardViewModel? {
       if getLoadedCardsCount() == 0 {
        Debug.log("MainViewModel.getNextCard()", "no cards")
        return nil}
        let card = cards.removeFirst()
        loadMoreIfNeeded()
        return card
    }
    
     func loadMoreIfNeeded(){
        if cards.count < 5 {
            loadCards {
                Debug.log("MainViewModel.loadMoreIfNeeded()", "loading more posts")
                self.loadMoreIfNeeded()
            }
        }
    }
    
    func getCurrentCard() -> CardViewModel {
        return cards.first!
    }
    func getLoadedCardsCount() -> Int {
        return cards.count
    }
}
