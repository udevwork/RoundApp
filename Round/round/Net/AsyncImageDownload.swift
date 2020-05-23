//
//  AsyncImageDownload.swift
//  round
//
//  Created by Denis Kotelnikov on 25.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageURL: URL?, placeholder: String, complition : ((HTTPResult)->())? = nil){
        self.kf.indicatorType = .activity
        
        self.kf.setImage(with: imageURL, placeholder: UIImage(named: placeholder)!, options: .none, progressBlock: { (progress, from) in
            //debugPrint("current: \(progress) / \(from)")
        }) { downloadResult in
            switch downloadResult {
            case .failure(_): /// let .failure(err):
               // debugPrint("AsyncImageDownload.setImage() Job failed: \(err.localizedDescription)")
                complition?(.error)
            case .success(_): /// let .success(imageResult):
              //  debugPrint("AsyncImageDownload.setImage() Task done for: \(imageResult.source.url?.absoluteString ?? "")")
                complition?(.success)
            }
        }
    }
    
    func setImage(imageURL: URL?, placeholder: UIImage, complition : ((HTTPResult)->())? = nil){
           self.kf.indicatorType = .activity
           
           self.kf.setImage(with: imageURL, placeholder: placeholder, options: .none, progressBlock: { (progress, from) in
               //debugPrint("current: \(progress) / \(from)")
           }) { downloadResult in
               switch downloadResult {
               case .failure(_): /// let .failure(err):
                  // debugPrint("AsyncImageDownload.setImage() Job failed: \(err.localizedDescription)")
                   complition?(.error)
               case .success(_): /// let .success(imageResult):
                 //  debugPrint("AsyncImageDownload.setImage() Task done for: \(imageResult.source.url?.absoluteString ?? "")")
                   complition?(.success)
               }
           }
       }
}
