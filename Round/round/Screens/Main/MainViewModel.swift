//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    public var cards : [CardViewModel] = []
    
    func loadNewPost(complition : @escaping ()->()) {
        FirebaseAPI.shared.getPosts { (result, model) in
            if result == .success {
                self.cards = model!
                complition()
            }
        }
    }

}
