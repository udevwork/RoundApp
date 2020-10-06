//
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

class SubscriptionsiewController: BaseViewController<SubscriptionsViewModel> {
    
    var package: Purchases.Package? = nil
    
    let nameLabel = Text(.title, .label)
    let delimiter: UIView = UIView()
    let dascriptionLabel = Text(.article, .systemGray2)
    
    let subscribeButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setColor(.systemGray3)
        .setText("subscribe")
        .setTextColor(.white)
        .setIcon(.cart)
        .setIconColor(.white)
        .setCornerRadius(13)
        .build()
    
    let restoreButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setColor(.systemGray3)
        .setText("restore")
        .setTextColor(.white)
        .setIcon(.cart)
        .setIconColor(.white)
        .setCornerRadius(13)
        .build()
    
    override init(viewModel: SubscriptionsViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Subscribe"
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        nameLabel.numberOfLines = 0
        dascriptionLabel.numberOfLines = 0
        
        
        nameLabel.text = "IDesigner subscription"
        
        view.addSubview(nameLabel)
        nameLabel.easy.layout(Top(70),Leading(40),Trailing(40))
        nameLabel.sizeToFit()
        
        view.addSubview(delimiter)
        delimiter.easy.layout(Top(5).to(nameLabel),Leading(40),Trailing(40),Height(1))
        delimiter.backgroundColor = .systemGray2
        
        view.addSubview(dascriptionLabel)
        dascriptionLabel.easy.layout(Top(20).to(nameLabel),Leading(40),Trailing(40))
        dascriptionLabel.sizeToFit()
        
        view.addSubview(subscribeButton)
        subscribeButton.easy.layout(Top(40).to(dascriptionLabel),Leading(40))
        view.addSubview(restoreButton)
        restoreButton.easy.layout(Top(10).to(subscribeButton),Leading(40))
        
        subscribeButton.setTarget {
            self.subscribeButton.showLoader(true)
            if Purchases.canMakePayments() {
                if let package = self.package {
                    Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                        if let info = purchaserInfo?.entitlements["IDesignerSubscriber"], info.isActive == true {
                            debugPrint("UNLOCKED")
                            Notifications.shared.Show(RNSimpleView(text: "Succsess!", icon: Icons.checkmark.image(), iconColor: .systemGreen))
                            self.setupInfo()
                        }
                        self.subscribeButton.showLoader(false)
                    }
                }
            } else {
                Notifications.shared.Show(RNSimpleView(text: "You cant purchase!", icon: Icons.cross.image(), iconColor: .systemRed))
            }
        }
        
        restoreButton.setTarget {
            Purchases.shared.restoreTransactions { (purchaserInfo, error) in
                debugPrint("RESTORE")
                debugPrint(purchaserInfo as Any)
                Notifications.shared.Show(RNSimpleView(text: "Restored!", icon: Icons.checkmark.image(), iconColor: .systemGreen))
            }
        }
    }
    
    private func setupInfo() {
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let error = error {
                print(error)
                return
            }
            if let info = purchaserInfo {
                if info.entitlements["IDesignerSubscriber"]?.isActive == true {
                    self.showUserAlredySubscribed()
                } else {
                    self.showPurcheseButton()
                }
            } else {
                debugPrint("no purchaserInfo")
            }
            
        }
    }
    
    private func showPurcheseButton(){
        Purchases.shared.offerings { [self] (offerings, error) in
            if let error = error {
                debugPrint("ERROR")
                debugPrint(error.localizedDescription)
                return
            }
            if let offerings = offerings {
                print(offerings.current?.availablePackages as Any)
                if let package = offerings.current?.availablePackages.first {
                    self.package = package
                    var res: String = ""
                    res += "\n \(package.localizedIntroductoryPriceString)"
                    res += "\n \(package.localizedPriceString)"
                    res += "\n \(package.product.localizedTitle)"
                    res += "\n \(package.product.localizedDescription)"
                    dascriptionLabel.text = res
                    
                    subscribeButton.isHidden = false
                    restoreButton.isHidden = false
                }
            }
    
        }
    }
    
    private func showUserAlredySubscribed(){
        var res: String = ""
        
        res += "Good!"
        res += "You alredy subscibed!"
        dascriptionLabel.text = res
        
        subscribeButton.isHidden = true
        restoreButton.isHidden = true
    }
    
}


