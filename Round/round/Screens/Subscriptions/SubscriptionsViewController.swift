
//  SignInViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Purchases
import Gemini

class SubscriptionsViewController: BaseViewController<SubscriptionsViewModel>, UITableViewDelegate, UITableViewDataSource  {

    private var drugtumbler: UIView = UIView()
    let content: UIView = UIView()
    fileprivate let table : UITableView = UITableView()

    
    let wallpaper: UIView = UIView()
    public var titleLable: Text = Text(.title,.white)
    public var priceLable: Text = Text(.big,.white)
    public var timeLable: Text = Text(.article,.white)

    public let subscribeButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 80)))
        .setStyle(.iconText)
        .setColor(.systemIndigo)
        .setTextColor(.white)
        .setIcon(.cart)
        .setIconColor(.white)
        .setCornerRadius(25)
        .setTextCentered()
        .setShadow(.subscribeButton)
        .build()

    override init(viewModel: SubscriptionsViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = .clear
        view.addSubview(content)
        view.addSubview(drugtumbler)

        content.addSubview(wallpaper)
        content.addSubview(table)
        content.addSubview(subscribeButton)
        content.addSubview(priceLable)
        content.addSubview(timeLable)
        content.addSubview(titleLable)

        content.backgroundColor = .systemGray6
        content.layer.cornerRadius = 30
        content.layer.masksToBounds = true
        content.easy.layout(Bottom(5 + Design.safeArea.bottom), Leading(5), Trailing(5), Top(6).to(drugtumbler))
        
        drugtumbler.layer.cornerRadius = 3
        drugtumbler.backgroundColor = .systemGray
        drugtumbler.easy.layout(Top(), Width(50), Height(6), CenterX())
        
        wallpaper.backgroundColor = .systemIndigo
        wallpaper.easy.layout(Top(),Leading(),Trailing(), Bottom(-20).to(priceLable, .bottomMargin))
        
        titleLable.easy.layout(Leading(20), Trailing(20), Top(20))
        titleLable.text = localized(.subs)
        
        if let package = SubscriptionsViewModel.package {
            priceLable.easy.layout(Leading(20), Top().to(titleLable))
            priceLable.text = "\(package.localizedPriceString)"
            
            timeLable.easy.layout(Leading().to(priceLable), Top().to(priceLable, .topMargin))
            timeLable.text = "/\(localized(.week))"
            timeLable.alpha = 0.7
        }
       
        table.delegate = self
        table.dataSource = self
        table.register(SubscribeCellTitle.self, forCellReuseIdentifier: "Title")
        table.register(SubscribeCellBenefit.self, forCellReuseIdentifier: "Benefit")
        table.register(SubscribeCellInfo.self, forCellReuseIdentifier: "Info")
        table.register(SubscribeCellTerms.self, forCellReuseIdentifier: "Terms")
        table.easy.layout(Top().to(wallpaper),Bottom(),Leading(),Trailing())
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        subscribeButton.easy.layout(CenterX(),Bottom(20),Height(50),Leading(20), Trailing(20))
        subscribeButton.setText(localized(.subscribe))
        
        subscribeButton.setTarget {
            self.subscribeButton.showLoader(true)
            if Purchases.canMakePayments() {
                if let package = SubscriptionsViewModel.package {
                    Purchases.shared.purchasePackage(package) { [weak self] (transaction, purchaserInfo, error, userCancelled) in
                        self?.subscribeButton.showLoader(false)
                        if userCancelled == false {
                            self?.dismiss(animated: true, completion: {
                                Notifications.shared.Show(RNSimpleView(text: localized(.unlocked), icon: Icons.checkmark.image(), iconColor: .systemGreen))
                                SubscriptionsViewModel.userSubscibed = true
                            })
                        }
                    }
                }
            } else {
                Notifications.shared.Show(RNSimpleView(text: localized(.purchaseError), icon: Icons.cross.image(), iconColor: .systemRed))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        let model = viewModel.model[indexPath.row]
        
        switch model {
        case .Benefit(let data):
            cell = tableView.dequeueReusableCell(withIdentifier: "Benefit")
            (cell as! SubscribeCellBenefit).setup(data: data)
        case .Info(let data):
            cell = tableView.dequeueReusableCell(withIdentifier: "Info")
            (cell as! SubscribeCellInfo).setup(data: data)
        case .Terms(let data):
            cell = tableView.dequeueReusableCell(withIdentifier: "Terms")
            (cell as! SubscribeCellTerms).setup(data: data)
        case .Title(let data):
            cell = tableView.dequeueReusableCell(withIdentifier: "Title")
            (cell as! SubscribeCellTitle).setup(data: data)
        }
        
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


