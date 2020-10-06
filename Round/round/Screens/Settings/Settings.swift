//
//  Settings.swift
//  round
//
//  Created by Denis Kotelnikov on 06.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation


import Foundation
import UIKit
import EasyPeasy
import PDFKit

class SettingsRouter {
    static func assembly() -> UIViewController{
        return SettingsViewController(viewModel: SettingsModel())
    }
}

struct SettingCellModel {
    var title: String
    var icon: Icons
    var onPress: (()->())
}

class SettingsModel {
    var model: [SettingCellModel] = []
}

class SettingsViewController: BaseViewController<SettingsModel>, UITableViewDelegate, UITableViewDataSource {
    
    
    fileprivate let table : UITableView = UITableView()
    
    override init(viewModel: SettingsModel) {
        super.init(viewModel: viewModel)
        setupModel()
        
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.easy.layout(Bottom(),Leading(), Trailing(), Top(20))
        table.register(SettingCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
    }
    
    private func setupModel(){
        viewModel.model = [
            SettingCellModel(title: "One", icon: .checkmark, onPress: {
                print("fuck1")
            }),
            SettingCellModel(title: "two", icon: .arrayDown, onPress: {
                print("fuck2")
            }),
            SettingCellModel(title: "three", icon: .cloud, onPress: {
                self.present(PDFViewer(file: .agreement), animated: true, completion: nil)
            }),
            SettingCellModel(title: "four", icon: .editorAddPhoto, onPress: {
                print("fuck4")
            })
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        let model = viewModel.model[indexPath.row]
        cell.setup(title: model.title, image: model.icon.image())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.model[indexPath.row].onPress()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

class SettingCell: UITableViewCell {
    private var content: UIView = UIView()
    private var title: Text = Text(.title, .label)
    private var icon: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign() {
        backgroundColor = .clear
        
        addSubview(content)
        content.layer.cornerRadius = 25
        content.backgroundColor = .systemGray6
        content.easy.layout(Leading(20),Trailing(20),Top(10),Bottom(10))
        content.setupShadow(preset: .Post)
        
        content.addSubview(icon)
        icon.easy.layout(Size(20),CenterY(),Leading(20))
        icon.contentMode = .scaleAspectFill
        icon.tintColor = .white
        content.addSubview(title)
        title.easy.layout(Leading(20).to(icon), CenterY())
        title.numberOfLines = 1
        
        selectionStyle = .none
    }
    
    public func setup(title: String,image: UIImage){
        icon.image = image
        self.title.text = title
    }
    
}
