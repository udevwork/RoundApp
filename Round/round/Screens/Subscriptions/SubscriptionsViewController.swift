
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

class SubscriptionsViewController: BaseViewController<SubscriptionsViewModel>  {

    private var drugtumbler: UIView = UIView()
    let content: UIView = UIView()
    
    let wallpaper: UIView = UIView()
    public var titleLable: Text = Text(.title,.white)
    public var priceLable: Text = Text(.big,.white)
    public var timeLable: Text = Text(.regular,.white)
    public var descriptionLable: Text = Text(.article, .systemIndigo)

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
        content.addSubview(subscribeButton)
        content.addSubview(priceLable)
        content.addSubview(timeLable)
        content.addSubview(titleLable)
        content.addSubview(descriptionLable)

        content.backgroundColor = .systemGray6
        content.layer.cornerRadius = 30
        content.layer.masksToBounds = true
        content.easy.layout(Bottom(5 + Design.safeArea.bottom), Leading(5), Trailing(5), Top(50))
        
        drugtumbler.layer.cornerRadius = 3
        drugtumbler.backgroundColor = .systemGray
        drugtumbler.easy.layout(Bottom(6).to(content, .top), Width(50), Height(6), CenterX())
        
        wallpaper.backgroundColor = .systemIndigo
        wallpaper.easy.layout(Top(),Leading(),Trailing(), Bottom(-20).to(priceLable, .bottomMargin))
        
        titleLable.easy.layout(Leading(20), Trailing(20), Top(20))
        titleLable.text = localized(.subs)
        
        if let package = SubscriptionsViewModel.package {
            priceLable.easy.layout(Leading(20), Top().to(titleLable))
            priceLable.text = "\(package.localizedPriceString)"
            
            timeLable.easy.layout(Leading().to(priceLable), Top().to(priceLable, .topMargin))
            timeLable.text = "/\(localized(.week)))"
            timeLable.alpha = 0.5
        }
        descriptionLable.easy.layout(Leading(20), Trailing(20), Top(20).to(wallpaper))
        descriptionLable.numberOfLines = 0
        descriptionLable.lineBreakMode = .byTruncatingTail
        descriptionLable.text = localized(.subDescription)
        
        let mainStack = vStack([
            hStack([ icon(), text(localized(.subone)), spacing()]),
            hStack([ icon(), text(localized(.subtwo)), spacing()]),
            hStack([ icon(), text(localized(.subthree)), spacing()]),
            hStack([ icon(), text(localized(.subfour)), spacing()])
        ])
        content.addSubview(mainStack)
        mainStack.easy.layout(Top(20).to(descriptionLable), Leading(20), Trailing(20))
        
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
    
    func text(_ t: String) -> UIView {
        let lable = Text(.article, .label)
        lable.text = t
        lable.numberOfLines = 1
        return lable
    }
    
    func icon() -> UIView {
        let i = UIImageView(image: Icons.checkmark.image())
        i.tintColor = .systemIndigo
        i.contentMode = .scaleAspectFit
        return i
    }
    
    func spacing(_ space: CGFloat = 0) -> UIView {
        let s = UIView(frame: CGRect(origin: .zero, size: CGSize(width: space, height: 0)))
        return s
    }
    
    func vStack(_ v: [UIView]) -> UIView {
        let stack = UIStackView(arrangedSubviews: v)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }
    
    func hStack(_ v: [UIView]) -> UIView {
        let stack = UIStackView(arrangedSubviews: v)
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }
    
}

