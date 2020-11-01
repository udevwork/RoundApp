//
//  IconEdotorIconsListViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 31.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class IconEditorIconsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public let table: UITableView = UITableView()
    public var onSelectImage: ((UIImage)->())?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.register(IconEditorIconCell.self, forCellReuseIdentifier: "cell")
        table.easy.layout(Edges())
        self.modalPresentationStyle = .automatic
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell as! IconEditorIconCell).setupView(image: UIImage(named: "social_\(indexPath.row)")!, name: String(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectImage?(UIImage(named: "social_\(indexPath.row)")!)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class IconEditorIconCell: UITableViewCell {
    
    let icon: UIImageView = UIImageView()
    let iconName: Text = Text(.article, .systemGray4)
    
    func setupView(image: UIImage, name: String){
        addSubview(icon)
        icon.easy.layout(Leading(20), CenterY(), Size(35))
        icon.tintColor = .label
        icon.image = image
        addSubview(iconName)
        iconName.easy.layout(Leading(20).to(icon), CenterY(),Trailing(20))
        iconName.text = name
        iconName.textAlignment = .right
    }
}
