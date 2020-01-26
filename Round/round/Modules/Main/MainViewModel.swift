//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    let user : User = User(ID: 0, avatarImageURL: nil, userName: nil)
    private var cards : [CardViewModel] = []

    
    // load cards at first loading and as adding to present cards, pagination not needed
    func loadCards(_ complition : (()->())?)  {
        Network.fetchPosts { cards in
            self.cards.append(contentsOf: cards)
            
            complition?()
        }
    }
    
    func getNextCard() -> CardViewModel? {
       if getLoadedCardsCount() == 0 { print("no cards"); return nil}
        let card = cards.removeFirst()
        loadMoreIfNeeded()
        return card
    }
    
     func loadMoreIfNeeded(){
        if cards.count < 5 {
            loadCards {
                print("loading additional posts")
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
