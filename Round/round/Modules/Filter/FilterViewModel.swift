//
//  FilterViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 10.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit

protocol SearchableModelProtocol {
    var searchParameter : String { get }
}

class CityModel: SearchableModelProtocol {
    var searchParameter: String { return cityName }
    let cityName : String
    
    init(cityName : String) {
        self.cityName = cityName
    }
}

class UserModel: SearchableModelProtocol {
    var searchParameter: String { return userName }
    let userName : String
    let avatar : UIImage
    
    init(userName : String, useravatar : UIImage) {
        self.userName = userName
        self.avatar = useravatar
    }
}

class FilterViewModel {
    var searchableModel : [SearchableModelProtocol]
    let searchableModelOriginal : [SearchableModelProtocol]
    let searchCellType : SearchableCell.Type
    let navigationTitle : String
    
    init(navigationTitle : String, searchableModel : [SearchableModelProtocol], searchCellType : SearchableCell.Type) {
        self.navigationTitle = navigationTitle
        self.searchableModelOriginal = searchableModel
        self.searchableModel = searchableModel
        self.searchCellType = searchCellType
    }
}
