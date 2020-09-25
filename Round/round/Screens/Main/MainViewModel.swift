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
    public var reloadCount: Int = 0

    
    func loadNewPost(complition : @escaping ([IndexPath])->()) {
        
        FirebaseAPI.shared.getRandomPost { [weak self] res, data  in
            if res == .error { return }
            if self == nil { return }
            if self!.reloadCount > 3 { return }
            var indexPaths : [IndexPath] = []
        
            if let data = data, data.count != 0 {
                print(data)
                for i in 0...data.count-1 {
                    print(data[i].title)
                    indexPaths.append(IndexPath(row: self!.cards.count+i, section: 0))
                }
                
                self?.cards.append(contentsOf: data)
                complition(indexPaths)
                self!.reloadCount = 0
            } else {
             // reload
            }
            
        }
    }

}
