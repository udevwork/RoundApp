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
    
    var onAddFilterPress : ()->() = {}
    
    fileprivate var collection : UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.sectionInset = UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width - 250)/2, bottom: 0, right: 0)
        let collect = UICollectionView(frame: .zero, collectionViewLayout: flow)
        return collect
    }()
    
    private let addfilterIdentifier = "addfilter"
    private let filterItemIdentifier = "filterItem"
    private var items = ["Add filter"] // defoult button
    
    func setup(){
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        collection.register(AddFilterButton.self, forCellWithReuseIdentifier: addfilterIdentifier)
        collection.register(FilterTag.self, forCellWithReuseIdentifier: filterItemIdentifier)
        addSubview(collection)
        
        collection.easy.layout(Edges())
        collection.backgroundColor = .clear
        
        
    }
    
    func addTag(tagName : String){
        items.append(tagName)
        collection.reloadData()
    }
    
    func removeTag(tagToRemove : String){
        items.removeAll { curTag -> Bool in
            return tagToRemove == curTag
        }
        collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : FilterItem?
        
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: addfilterIdentifier, for: indexPath) as? AddFilterButton
            
            cell?.onIconPress = { [weak self] _ in
                self?.onAddFilterPress()
            }
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterItemIdentifier, for: indexPath) as? FilterItem
            
            cell?.onIconPress = { [weak self] tag in
                self?.removeTag(tagToRemove: tag)
            }
        }
        
        guard let finalcell = cell else { return UICollectionViewCell() }
        finalcell.setup(text: items[indexPath.row])
        return finalcell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text : UILabel = UILabel()
        text.text = items[indexPath.row]
        text.sizeToFit()
        let w : CGFloat = text.bounds.width + 60
        return CGSize(width: w, height: 30)
    }
}
