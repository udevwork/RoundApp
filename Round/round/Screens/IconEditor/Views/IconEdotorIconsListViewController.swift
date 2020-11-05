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

class IconEditorIconsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    struct Icon {
        var iconName: String
        var icon: UIImage
    }
    
    struct IconsBundle {
        var bundleName: String
        var bundlePathName: String
        var useOriginalColor: Bool
    }
    
    public var currentBundle: IconsBundle!
    public var bundles: [IconsBundle] = []
    public let table: UITableView = UITableView()
    public var onSelectImage: ((UIImage)->())?
    var iconsData: [Icon] = []
    var searchIconsData: [Icon] = []

    
    let selector: UISegmentedControl = UISegmentedControl()
    let searchBar: UISearchBar = UISearchBar()
    var isSearching: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Colors.vcBackground.uicolor()
        view.addSubview(table)
        view.addSubview(searchBar)
        view.addSubview(selector)

        table.delegate = self
        table.dataSource = self
        table.register(IconEditorIconCell.self, forCellReuseIdentifier: "cell")
        self.modalPresentationStyle = .automatic
        
        loadBundles()
        loadImages(bundle: currentBundle)
        
        for b in bundles.reversed() {
            selector.insertSegment(withTitle: b.bundleName, at: 0, animated: false)
        }
        selector.easy.layout(Top(20),Leading(20),Trailing(20))
        selector.addTarget(self, action: #selector(bundleChange), for: .valueChanged)
        table.backgroundColor = .clear
        table.easy.layout(Top(20).to(searchBar), Leading(), Trailing(), Bottom())
        table.keyboardDismissMode = .onDrag
        selector.selectedSegmentIndex = 0
        
        searchBar.easy.layout(Top(20).to(selector),Leading(15),Trailing(15))
        searchBar.tintColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func bundleChange(_ sander: UISegmentedControl) {
        iconsData = []
        searchIconsData = []
        currentBundle = bundles[sander.selectedSegmentIndex]
        loadImages(bundle: currentBundle)
        if isSearching {
            self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
        }
        table.reloadData()
    }
    
    func loadBundles(){
        bundles.append(contentsOf: [
            IconsBundle(bundleName: "Fill", bundlePathName: "fill", useOriginalColor: false),
            IconsBundle(bundleName: "Lined", bundlePathName: "line", useOriginalColor: false),
            IconsBundle(bundleName: "Color", bundlePathName: "color", useOriginalColor: true),
            IconsBundle(bundleName: "Color 2", bundlePathName: "colorline", useOriginalColor: true)
        ])
        
        currentBundle = bundles[0]
    }
    
    public func loadImages(bundle: IconsBundle){
        
        let urls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: "\(bundle.bundlePathName).bundle")
        
        urls?.forEach({ url in
            do {
                let firstImageData = try Data(contentsOf: url)
                let firstImage = UIImage(data: firstImageData)
                if firstImage != nil {
                    let icon = Icon(iconName: url.lastPathComponent.dropLast(4).capitalized,
                                    icon: firstImage!.withRenderingMode( bundle.useOriginalColor ? .alwaysOriginal : .alwaysTemplate))
                    iconsData.append(icon)
                } else {
                    print("fuck: get nil")
                }
            } catch {
                print("fuck: get error")
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchIconsData.count
        } else {
            return iconsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            (cell as! IconEditorIconCell).setupView(data: searchIconsData[indexPath.row], index: indexPath.row+1)
        } else {
            (cell as! IconEditorIconCell).setupView(data: iconsData[indexPath.row], index: indexPath.row+1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            onSelectImage?(searchIconsData[indexPath.row].icon)
        } else {
            onSelectImage?(iconsData[indexPath.row].icon)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            table.reloadData()
            return
        }
        isSearching = true
        searchIconsData = []
        for i in iconsData {
            if i.iconName.contains(searchText) {
                searchIconsData.append(i)
            }
        }
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        table.reloadData()
    }
}

class IconEditorIconCell: UITableViewCell {
    
    let icon: UIImageView = UIImageView()
    let iconCountLable: Text = Text(.article, .systemGray4)
    let iconNameLable: Text = Text(.title, .systemGray)
    
    func setupView(data: IconEditorIconsListViewController.Icon, index: Int){
        addSubview(icon)
        icon.easy.layout(Leading(20), CenterY(), Size(35))
        icon.tintColor = .label
        icon.image = data.icon
        addSubview(iconCountLable)
        iconCountLable.easy.layout(CenterY(),Trailing(20))
        iconCountLable.text = String(index)
        iconCountLable.textAlignment = .right
        
        addSubview(iconNameLable)
        iconNameLable.easy.layout(Leading(20).to(icon), CenterY())
        iconNameLable.text = data.iconName
        
        backgroundColor = .clear
    }
}
