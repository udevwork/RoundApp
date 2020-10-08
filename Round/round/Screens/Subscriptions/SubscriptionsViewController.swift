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

class SubscriptionsViewController: BaseViewController<SubscriptionsViewModel> {
    
    var package: Purchases.Package? = nil
    
    let header: TitleHeader = TitleHeader()
    
    let dascriptionLabel = Text(.article, .systemGray2)
    
    let subscribeButton : Button = ButtonBuilder()
        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 40)))
        .setStyle(.iconText)
        .setColor(.systemGray3)
        .setText(localized(.subscribe))
        .setTextColor(.white)
        .setIcon(.cart)
        .setIconColor(.white)
        .setCornerRadius(13)
        .build()
    
    override init(viewModel: SubscriptionsViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .never
        title = "Subscribe"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setupInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        dascriptionLabel.numberOfLines = 0
        
        header.text = localized(.subs)
        
        view.addSubview(header)
        header.easy.layout(Top(Design.safeArea.top + 10),Leading(),Trailing(),Height(40))

      
        view.addSubview(dascriptionLabel)
        dascriptionLabel.easy.layout(Top(20).to(header),Leading(40),Trailing(40))
        dascriptionLabel.sizeToFit()
        
        view.addSubview(subscribeButton)
        subscribeButton.easy.layout(Top(40).to(dascriptionLabel),Leading(40))
       
        
        subscribeButton.setTarget {
            self.subscribeButton.showLoader(true)
            if Purchases.canMakePayments() {
                if let package = self.package {
                    Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
                        if let info = purchaserInfo?.entitlements["IDesignerSubscriber"], info.isActive == true {
                            debugPrint("UNLOCKED")
                            Notifications.shared.Show(RNSimpleView(text: localized(.unlocked), icon: Icons.checkmark.image(), iconColor: .systemGreen))
                            self.setupInfo()
                        }
                        self.subscribeButton.showLoader(false)
                    }
                }
            } else {
                Notifications.shared.Show(RNSimpleView(text: localized(.purchaseError), icon: Icons.cross.image(), iconColor: .systemRed))
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
    }
    
}


