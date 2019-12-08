//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    let user : User
    var cards : [CardViewModel]
    
    // Settings
    let cardsCountToLoad : Int8 = 40
    
    init(user : User, cards : [CardViewModel]?) {
        self.user = user
        self.cards = cards ?? []
    }
    
    // load cards at first loading and as adding to present cards, pagination not needed
    func loadCards()  {
        
    }
    
    
}
