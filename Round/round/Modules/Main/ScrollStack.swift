//
//  ScrollStack.swift
//  round
//
//  Created by Denis Kotelnikov on 02.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class ScrollStack: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate var collection : UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collect = UICollectionView(frame: .zero, collectionViewLayout: flow)
        return collect
    }()
    
    private let cellReuseIdentifier = "collectionCell"
    let items = ["add filter", "USA","LOS-ANGELES","health"]
    
     func setup(){
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = true
        
        collection.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
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
        
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MyCollectionViewCell
        
           cell.setup(text: items[indexPath.row])
           return cell
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 200, height: 30)
    }
    
    
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
       {
        
           return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
       }
}

class MyCollectionViewCell: UICollectionViewCell {
    
    let label : Text = Text(fontName: .Medium, size: 12)
    
    func setup(text : String){
       // frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        addSubview(label)
        backgroundColor = #colorLiteral(red: 0.445202948, green: 0.4199092588, blue: 1, alpha: 1)
        roundCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 13)
        label.text = text

        label.textColor = .black
        label.easy.layout(Top(),Bottom(),Leading(),Trailing())
        label.sizeToFit()
        sizeToFit()
    }
}

