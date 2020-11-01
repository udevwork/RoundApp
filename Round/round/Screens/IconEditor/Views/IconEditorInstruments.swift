//
//  IconEditorInstruments.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

protocol IconEditorInstrumentsDelegate: NSObject {
    func editor(indexForInstrument: Int, in instruments: IconEditorInstruments) -> EditorIntsrument
    func editor(countOfForInstrument instruments: IconEditorInstruments) -> Int
}

class IconEditorInstruments: UIView {
    
    weak var delegate: IconEditorInstrumentsDelegate?
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 85, height: 90)
        layout.minimumLineSpacing = -5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collection
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(collection)
        self.backgroundColor = .clear
        collection.backgroundColor = .clear
        collection.easy.layout(Top(),Bottom(),Leading(),Trailing())
        collection.delegate = self
        collection.dataSource = self
        collection.register(IconEdotorInstrumentCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension IconEditorInstruments: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.editor(countOfForInstrument: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let instrument = delegate?.editor(indexForInstrument: indexPath.row, in: self)
        (cell as! IconEdotorInstrumentCell).setupView(instrument!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instrument = delegate?.editor(indexForInstrument: indexPath.row, in: self)
        instrument?.onPress()
    }
}

class IconEdotorInstrumentCell: UICollectionViewCell {
    private let icon: UIImageView = UIImageView()
    private let lable: Text = Text(.regular, .label)
    
    func setupView(_ instrument: EditorIntsrument){
        addSubview(icon)
        icon.tintColor = .label
        icon.image = instrument.icon
        icon.contentMode = .scaleAspectFit
        addSubview(lable)
        lable.text = instrument.lableText
        lable.textAlignment = .center
        lable.numberOfLines = 2
        icon.easy.layout(CenterX(),CenterY(),Size(30))
        lable.easy.layout(Top(4).to(icon),Leading(),Trailing())
    }
}
