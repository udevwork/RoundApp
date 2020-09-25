//
//  PostViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

enum LoadedImageType {
    case cashe
    case url
}

class PostViewModel {
    
    let cardView : CardView
    var postBlocks : [BasePostCellViewModelProtocol] = []
    
    init(cardView : CardView) {
        self.cardView = cardView
    }
    
    func loadPostBody(complition : @escaping ()->()){
        FirebaseAPI.shared.getPostBody(id: cardView.viewModel!.id) { (HTTPResult, body) in
            if HTTPResult == .success {
                self.postBlocks = body!
                self.postBlocks = self.postBlocks.sorted { one, two in
                    one.order! < two.order!
                }
                complition()
            } else {
                print("fuck")
            }
        }
    }
    
  
    
}


