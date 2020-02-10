//
//  FilterSlider.swift
//  round
//
//  Created by Denis Kotelnikov on 02.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class FilterSlider: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var collection : UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collect = UICollectionView(frame: .zero, collectionViewLayout: flow)
        return collect
    }()
    
    private let addfilterIdentifier = "addfilter"
    private let filterItemIdentifier = "filterItem"
    let items = ["Add filter", "USA","LOS-ANGELES","health"]
    
    func setup(){
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        collection.register(AddFilterButton.self, forCellWithReuseIdentifier: addfilterIdentifier)
        collection.register(FilterTag.self, forCellWithReuseIdentifier: filterItemIdentifier)
        addSubview(collection)
        
        collection.easy.layout(Top(),Bottom(),Leading(),Trailing())
        collection.backgroundColor = .clear
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : FilterItem?
        if indexPath.row == 0 {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: addfilterIdentifier, for: indexPath) as! AddFilterButton
        } else {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterItemIdentifier, for: indexPath) as! FilterItem
        }
        guard let cellq = cell else {return FilterItem()}
        cellq.setup(text: items[indexPath.row])
        return cellq
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text : UILabel = UILabel()
        text.text = items[indexPath.row]
        text.sizeToFit()
        let w : CGFloat = text.bounds.width + 60
        return CGSize(width: w, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
