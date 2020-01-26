//
//  PostViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation

class PostViewModel {
    
    let cardView : CardView
    var postBlocks : [BasePostCellViewModelProtocol] = []
    
    init(cardView : CardView) {
        self.cardView = cardView
    }
    
    func loadPostBoady(complition : ()->()){
//        Network().getPostBody(id: cardView.viewModel!.id) { result in
//            DispatchQueue.main.async {
//                self.postBlocks = result
//               // complition()
//            }
//        }
    }
}


