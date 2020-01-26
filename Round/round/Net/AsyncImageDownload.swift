//
//  AsyncImageDownload.swift
//  round
//
//  Created by Denis Kotelnikov on 25.01.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url:String, placeholder: String){
        guard let url = URL(string: url) else {
            self.image = UIImage(named: placeholder)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {return}
            guard let data = data else { return }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }.resume()
        
    }
}
