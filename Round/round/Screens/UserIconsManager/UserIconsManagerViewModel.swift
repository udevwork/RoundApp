//
//  UserIconsManagerViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 12.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class UserIconsManagerViewModel: BaseViewModel {
    var router: UserIconsManagerRouter?
    typealias routerType = UserIconsManagerRouter
    
    let archivesLoaded: SingleObservable = SingleObservable()
    var achives: [iconsZipObject] = []
    
    func getArchives() {
        
        ProductManager().getArchives { [weak self] result in
            self?.achives = result
            
            result.forEach { o in
                print("image local path: ", o.imageLocalPath)
            }
            
            self?.archivesLoaded.call()
        }
        
    }
    
}
