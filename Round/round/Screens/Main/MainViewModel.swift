//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    public lazy var cards : [CardViewModel] = [templateCard()]
    
    func loadNewPost(complition : @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FirebaseAPI.shared.getPosts { (result, model) in
                if result == .success {
                    self.cards = model!
                    complition()
                }
            }
        }
    }

    private func templateCard() -> CardViewModel{
        return CardViewModel()
    }
    
}
