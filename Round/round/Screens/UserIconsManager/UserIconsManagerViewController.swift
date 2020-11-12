//
//  UserIconsManagerViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 12.11.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import EasyPeasy
import UIKit

class UserIconsManagerViewController: BaseViewController<UserIconsManagerViewModel> {
    
    let table: UITableView = UITableView()
    
    let placeholderIcon = UIImageView(image: Icons.save.image(weight: .medium))
    let placeholderLable = Text(.big, .systemGray2)
    let placeholderLableDescription = Text(.article, .systemGray4)

    override init(viewModel: UserIconsManagerViewModel) {
        super.init(viewModel: viewModel)
        viewModel.archivesLoaded.observe(self) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.achives.count > 0 {
                self.placeholder(show: false)
                self.table.reloadData()
            } else {
                self.placeholder(show: true)
            }
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.title =  "Icons manager"
        viewModel.getArchives()
    }
    
    func setupView() {
        view.addSubview(table)
        table.easy.layout(Edges())
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 60, right: 0)
        table.delegate = self
        table.dataSource = self
        table.register(UserIconManagerCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        
        view.addSubview(placeholderIcon)
        view.addSubview(placeholderLable)
        view.addSubview(placeholderLableDescription)

        placeholderIcon.easy.layout(Size(80),CenterX(),CenterY(-80))
        placeholderIcon.tintColor = .systemGray4
        placeholderLable.numberOfLines = 0
        placeholderLable.easy.layout(Top(20).to(placeholderIcon), Leading(40), Trailing(40))
        placeholderLable.textAlignment = .center
        placeholderLable.text = "No downloaded archives"
        placeholderLable.sizeToFit()
        
        placeholderLableDescription.easy.layout(Top(10).to(placeholderLable), Leading(40), Trailing(40))
        placeholderLableDescription.textAlignment = .center
        placeholderLableDescription.numberOfLines = 0
        placeholderLableDescription.text = "All archives that you download go here. Here you can easily unpack your icons without downloading them."
        placeholderLableDescription.sizeToFit()
        
    }
    
    func unpack(model: DownloadViewModel.Model) {
        let vc = DownloadViewController(model: model)
        self.present(vc, animated: true, completion: nil)
        vc.unzip()
    }
    
    func placeholder(show: Bool) {
        [placeholderLable, placeholderIcon, placeholderLableDescription].forEach { item in
            item.isHidden = !show
        }
    }
    
    deinit {
        viewModel.archivesLoaded.removeObserver(self)
    }
}

extension UserIconsManagerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.achives.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserIconManagerCell
        
        var image: UIImage? = nil
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("icons").appendingPathComponent("savedImages").appendingPathComponent(viewModel.achives[indexPath.row].imageLocalPath).absoluteString.replacingOccurrences(of: "file://", with: "")

        if let imgData = FileManager.default.contents(atPath: path){
            image = UIImage(data: imgData)
        }
        
        let model = DownloadViewModel.Model(link: "",
                                            downloadbleImage: image ?? Icons.archive.image(),
                                            downloadbleName: viewModel.achives[indexPath.row].archiveName,
                                            downloadbleDescription: viewModel.achives[indexPath.row].archiveDescription)
        
        cell?.setup(model: model)
        
        cell?.onPessUnpack = { [weak self] model in
            self?.unpack(model: model)
        }
        
        return cell ?? UITableViewCell()
    }
}
