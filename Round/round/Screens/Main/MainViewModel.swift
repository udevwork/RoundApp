//
//  MainViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 08.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class MainViewModel {
    public let user : User = User()
    public var cards : [CardViewModel] = []


    
    func loadNewPost(complition : @escaping (Int)->()) {
        
        FirebaseAPI.shared.getRandomPost { [weak self] res, models  in
            
            if let m = models {
                Debug.log("COUNT: ", m.count)
                if m.count == 0 {
                    self?.loadNewPost { r in
                        self?.cards.append(contentsOf: m)
                        complition(r)
                    }
                    return
                }
                self?.cards.append(contentsOf: m)
                complition(m.count)
            } else {
                Debug.log("nil")
            }
        }
    }

}
