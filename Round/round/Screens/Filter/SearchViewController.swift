//
//  Table.swift
//  round
//
//  Created by Denis Kotelnikov on 11.02.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class SearchViewController: BaseViewController<FilterViewModel> {

    
    let table : UITableView = UITableView()
    let search : SearchInput = SearchInput()
    
    var onCellPress : ((SearchableModelProtocol) -> ())?
    
    override init(viewModel: FilterViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .always
        title = viewModel.navigationTitle
        table.delegate = self
        table.dataSource = self
        table.easy.layout(Top(),Bottom(),Leading(),Trailing())
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.keyboardDismissMode = .onDrag
        register(cellType: viewModel.searchCellType)
        
        view.addSubview(search)
        view.addSubview(table)
        search.easy.layout(Top(100),Leading(20),Trailing(20), Height(50))
        table.easy.layout(Top().to(search),Leading(20),Trailing(20), Bottom())
        
        
        search.input.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != "" {
            viewModel.searchableModel = viewModel.searchableModelOriginal.filter { searchable -> Bool in
                if searchable.searchParameter.lowercased().contains(textField.text!.lowercased()){
                    return true
                }
                return false
            }
        } else {
            viewModel.searchableModel = viewModel.searchableModelOriginal
        }
        table.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func register(cellType: SearchableCell.Type) {
        table.register(cellType.self, forCellReuseIdentifier: viewModel.searchCellType.identifier)
    }
    
    func dequeue(indexPath: IndexPath) -> UITableViewCell{
        return table.dequeueReusableCell(withIdentifier: viewModel.searchCellType.identifier, for: indexPath)
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.searchableModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dequeue(indexPath: indexPath) as! SearchableCell
        cell.setup(viewModel.searchableModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellPress?(viewModel.searchableModel[indexPath.row])
        navigationController?.popViewController(animated: false)
    }
    
}


protocol SearchableCell : UITableViewCell {
    static var identifier : String { get }
    func setup(_ model: SearchableModelProtocol)
}

class CityCell : UITableViewCell, SearchableCell {
    static var identifier: String = "searchCell"
    
    let bg: UIView = UIView()
    let cityName: Text = Text(.article, .black, nil)
    
    func setup(_ model: SearchableModelProtocol) {
        guard let model = model as? CityViewModel else { return }
        addSubview(bg)
        bg.addSubview(cityName)
        
        cityName.text = model.cityName
        backgroundColor = .clear
        bg.backgroundColor = .common
        bg.layer.masksToBounds = true
        bg.layer.cornerRadius = 13
        
        bg.easy.layout(Top(20),Bottom(20),Leading(20),Trailing(20))
        cityName.easy.layout(Top(),Bottom(),Leading(20),Trailing(20))
        
    }
}



class UserCell : UITableViewCell, SearchableCell {
    static var identifier: String = "UserCell"
    
    let bg: UIView = UIView()
    let userName: Text = Text(.article, .error, nil)
    let avatar: UIImageView = UIImageView()
    
    func setup(_ model: SearchableModelProtocol) {
        guard let model = model as? UserViewModel else { return }
        
        selectionStyle = .none
        
        addSubview(bg)
        bg.addSubview(userName)
        bg.addSubview(avatar)
        
        userName.text = model.userName
        backgroundColor = .clear
        bg.backgroundColor = .warning
        bg.layer.masksToBounds = true
        bg.layer.cornerRadius = 13
        
        avatar.image = model.avatar
        
        bg.easy.layout(Top(20),Bottom(20),Leading(20),Trailing(20))
        avatar.easy.layout(CenterY(), Leading(20),Height(20), Width(20))
        userName.easy.layout(Top(),Bottom(),Leading(20).to(avatar),Trailing(20))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
    }
}
