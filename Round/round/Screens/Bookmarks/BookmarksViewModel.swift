//
//  BookmarksViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 20.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class BookmarksViewModel {
    var postsData: [CardViewModel] = []
    var postDataUpdated : Observable<[CardViewModel]?> = .init(nil)
    
    public func loadPosts(){
        FirebaseAPI.shared.getBookmarkedPostCards(userID: AccountManager.shared.data.uid) {[weak self] (res, cards) in
            if let data = cards {
            self?.postsData = data
            self?.postDataUpdated.value = data
            }
        }
    }
}
