//
//  RealmTest.swift
//  round
//
//  Created by Denis Kotelnikov on 23.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import EasyPeasy

class RealmTest: UIViewController {
    
    var realm: Realm!
    let table = UITableView(frame: UIScreen.main.bounds, style: .plain)
    var data: [RealmUser] = []
    
    init(){
        super.init(nibName: nil, bundle: nil)
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: "RealmUser") { (oldObj, newObj) in
                        newObj!["id"] = UUID().uuidString
                    }
                }
        })
        realm = try! Realm(configuration: config)
        setup()
        setupView()
        view.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    }
    
    func setupView() {
        title = "REALM DATABASE"
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let play = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(removeTapped))
        
        let clear = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAll))
        clear.tintColor = .red
        navigationItem.rightBarButtonItems = [add, play]
        navigationItem.leftBarButtonItems = [clear]
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.register(RealmUserCell.self, forCellReuseIdentifier: "cell")
        data = realm.objects(RealmUser.self).map({ u -> RealmUser in return u })
        table.reloadData()

    }
    
    @objc func clearAll(){
        let block = {
            self.realm.deleteAll()
        }
        try! realm.write(block)
        data = []
        table.reloadData()
    }
    
    @objc func addTapped (){
        let alert = UIAlertController(title: "Create", message: "new user", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert, weak self] action in
            debugPrint(alert?.textFields![0].text ?? "")
            debugPrint(alert?.textFields![1].text ?? "")
            
            self?.saveToRealm(id: UUID().uuidString, name: alert!.textFields![0].text!, age: alert!.textFields![1].text!)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func edit (user: RealmUser){
      
        let alert = UIAlertController(title: "Edit", message: "user", preferredStyle: .alert)
        alert.addTextField { field in
            field.text = user.name
        }
        alert.addTextField { field in
            field.text = user.age
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert, weak self] action in
            self?.saveToRealm(id: user.id!, name: alert!.textFields![0].text!, age: alert!.textFields![1].text!)
        }))
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func removeTapped (){
        table.isEditing = !table.isEditing
    }
    
    func saveToRealm(id: String, name: String, age: String){
        debugPrint("save: ", name, age)
        let block = {
            self.realm.create(RealmUser.self, value: ["id": id, "name": name, "age": age], update: .modified)
            
        }
        try! realm.write(block)
        data = realm.objects(RealmUser.self).map({ u -> RealmUser in return u })
        table.reloadData()
    }
}

class RealmUserCell: UITableViewCell {
    
    let label: UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 44))
    var user: RealmUser? = nil
    
    func setup(realmUser user: RealmUser) {
        self.user = user
        addSubview(label)
        label.numberOfLines = 0
        label.textColor = .label
        
        label.text = "\(user.name ?? "_"), \(user.age ?? "_")"
    }
    
}

extension RealmTest: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RealmUserCell
        cell.setup(realmUser: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let block = {
                guard let cell = tableView.cellForRow(at: indexPath) as? RealmUserCell, let u = cell.user else {
                    debugPrint("no cell or user")
                    return
                }
                guard let object = self.realm.object(ofType: RealmUser.self, forPrimaryKey: u.id) else {
                    debugPrint("no object with name: ", u.name ?? "")
                    return
                }
                self.realm.delete(object)
            }
            try! realm.write(block)
            data = realm.objects(RealmUser.self).map({ u -> RealmUser in return u })
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RealmUserCell, let u = cell.user else {
            debugPrint("no text")
            return
        }
        edit(user: u)
    }
}

class RealmUser: Object {
    @objc  dynamic var id: String?
    @objc  dynamic var name: String?
    @objc  dynamic var age: String? = ""
    @objc  dynamic var post: RealmPost? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class RealmPost: Object {
    @objc  dynamic var tite: String? = ""
}
