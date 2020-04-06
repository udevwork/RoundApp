//
//  SimplePhotoPostCellViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 27.12.2019.
//  Copyright © 2019 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

class SimplePhotoPostCellViewModel : BasePostCellViewModelProtocol{
    var order: Int?
    var type : PostCellType?
    let imageUrl : String?
    let cashe : NSCache<NSString, UIImage> =  NSCache()

    init(model : SimplePhotoResponse) {
        self.type = model.type
        self.imageUrl = model.imageUrl
        self.order = model.order
    }
    
    func lazyImageLoading(_ urlString:String,_ placeholder: String,_ complition : @escaping ((UIImage, LoadedImageType)->())){
             
           if let image = cashe.object(forKey: urlString as NSString) {
                 DispatchQueue.main.async {
                     complition(image, .cashe)
                 }
            return
             }
             
             guard let url = URL(string: urlString) else {
                DispatchQueue.main.async() {
                 complition(UIImage(named: placeholder)! , .cashe)
               }
                 return
             }
             
             URLSession.shared.dataTask(with: url) { data, response, error in
                 if error != nil {return}
                 guard let data = data else { return }
                 guard let image = UIImage(data: data) else {return}
               self.cashe.setObject(image, forKey: urlString as NSString)
                 DispatchQueue.main.async() {
                     complition(UIImage(data: data)!, .url)
                 }
             }.resume()
             
         }
}
