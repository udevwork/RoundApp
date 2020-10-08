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
import Purchases

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
    
    let header: TitleHeader = TitleHeader()
    fileprivate let table : UITableView = UITableView()
    
    
    override init(viewModel: SettingsModel) {
        super.init(viewModel: viewModel)
        setupModel()
        
        view.addSubview(table)
        view.addSubview(header)

        table.delegate = self
        table.dataSource = self
        table.easy.layout(Bottom(),Leading(), Trailing(), Top(20).to(header))
        table.register(SettingCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header.text = localized(.settings)
        header.easy.layout(Top(Design.safeArea.top + 10),Leading(),Trailing(),Height(40))
    }
    
    
    private func setupModel(){
        viewModel.model = [
            SettingCellModel(title: localized(.policy), icon: .doc, onPress: {
                print("fuck1")
            }),
            SettingCellModel(title: localized(.termsOfUse), icon: .userQuestion, onPress: {
                print("fuck2")
            }),
            SettingCellModel(title: localized(.сontactUs), icon: .email, onPress: {
                self.present(PDFViewer(file: .agreement), animated: true, completion: nil)
            }),
            SettingCellModel(title: localized(.subscriptionTerms), icon: .cart, onPress: {
                self.present(PDFViewer(file: .agreement), animated: true, completion: nil)
            }),
            SettingCellModel(title: localized(.restore), icon: .dollar, onPress: {
                Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                    debugPrint("RESTORE")
                    debugPrint(purchaserInfo as Any)
                    Notifications.shared.Show(RNSimpleView(text: localized(.purchaseRestore), icon: Icons.checkmark.image(), iconColor: .systemGreen))
                }
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
        return 70
    }

}

class SettingCell: UITableViewCell {
    private var content: UIView = UIView()
    private var title: Text = Text(.system, .label)
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
        content.layer.cornerRadius = 15
        content.backgroundColor = .systemGray6
        content.easy.layout(Leading(20),Trailing(20),Top(4),Bottom(4))
        
        content.addSubview(icon)
        icon.easy.layout(Size(20),CenterY(),Leading(20))
        icon.contentMode = .scaleAspectFill
        icon.tintColor = .systemGray
        content.addSubview(title)
        title.easy.layout(Leading(10).to(icon), CenterY())
        title.numberOfLines = 1
        
        selectionStyle = .none
    }
    
    public func setup(title: String,image: UIImage){
        icon.image = image
        self.title.text = title
    }
    
}
