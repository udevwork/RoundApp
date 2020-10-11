//
//  SignInViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//
//
//import Foundation
//import UIKit
//import EasyPeasy
//import Purchases
//import Gemini
//
//class SubscriptionsViewController: BaseViewController<SubscriptionsViewModel>, UITableViewDelegate, UITableViewDataSource  {
//
//    let wallpaper: UIImageView = UIImageView(image: Images.subsWallpaper.uiimage())
//
//    let header: TitleHeader = TitleHeader()
//    var selectedPackage: Purchases.Package? = nil
//
//    public var descriptionLable: Text = Text(.article,.label)
//
//    fileprivate let table : UITableView = UITableView()
//
//    public let subscribeButton : Button = ButtonBuilder()
//        .setFrame(CGRect(origin: .zero, size: CGSize(width: 125, height: 80)))
//        .setStyle(.iconText)
//        .setColor(.systemIndigo)
//        .setTextColor(.white)
//        .setText(localized(.subscribe))
//        .setIcon(.cart)
//        .setIconColor(.white)
//        .setCornerRadius(25)
//        .setTextCentered()
//        .setShadow(.subscribeButton)
//        .build()
//
//    override init(viewModel: SubscriptionsViewModel) {
//        super.init(viewModel: viewModel)
//        navigationItem.largeTitleDisplayMode = .never
//        setupView()
//        setupInfo()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        header.easy.layout(Top(Design.safeArea.top + 10),Leading(),Trailing(),Height(40))
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//
//        view.addSubview(wallpaper)
//        wallpaper.contentMode = .scaleAspectFill
//        wallpaper.easy.layout(Top(),Leading(-20),Trailing(-20),Height(UIScreen.main.bounds.height/2))
//
//        header.text = localized(.subs)
//        view.addSubview(header)
//        view.addSubview(table)
//
//        view.addSubview(descriptionLable)
//        descriptionLable.easy.layout(Leading(20), Trailing(20), Top(20).to(header), Bottom(20).to(table))
//        descriptionLable.numberOfLines = 0
//        descriptionLable.text = localized(.subDescription)
//        descriptionLable.lineBreakMode = .byTruncatingTail
//        view.addSubview(subscribeButton)
//
//        table.delegate = self
//        table.dataSource = self
//        table.easy.layout(Bottom(40).to(subscribeButton), Leading(), Trailing(), Height(75*3))
//        table.register(PricingCell.self, forCellReuseIdentifier: "cell")
//        table.separatorStyle = .none
//        table.backgroundColor = .clear
//        table.isScrollEnabled = false
//        subscribeButton.easy.layout(CenterX(),Bottom(30),Height(50),Leading(20), Trailing(20))
//
//
//        subscribeButton.setTarget {
//            self.subscribeButton.showLoader(true)
//            if Purchases.canMakePayments() {
//                if let package = self.selectedPackage {
//                    Purchases.shared.purchasePackage(package) { [weak self] (transaction, purchaserInfo, error, userCancelled) in
//                        if let info = purchaserInfo?.entitlements["IDesignerSubscriber"], info.isActive == true {
//                            debugPrint("UNLOCKED")
//                        }
//                        self?.subscribeButton.showLoader(false)
//                        self?.dismiss(animated: true, completion: {
//                            Notifications.shared.Show(RNSimpleView(text: localized(.unlocked), icon: Icons.checkmark.image(), iconColor: .systemGreen))
//                        })
//                    }
//                }
//            } else {
//                Notifications.shared.Show(RNSimpleView(text: localized(.purchaseError), icon: Icons.cross.image(), iconColor: .systemRed))
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if self.viewModel.model.count > 2 {
//                self.selectedPackage = self.viewModel.model[1].package
//                let cell = (self.table.cellForRow(at: IndexPath(row: 1, section: 0)) as! PricingCell)
//                cell.select()
//                self.table.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .top)
//            }
//        }
//
//    }
//
//    private func setupInfo() {
//        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
//            if let error = error {
//                debugPrint(error)
//                return
//            }
//            if let info = purchaserInfo {
//                if info.entitlements["IDesignerSubscriber"]?.isActive == true {
//                    //self.showUserAlredySubscribed()
//                } else {
//                    self.showPurcheseButton()
//                }
//            } else {
//                debugPrint("no purchaserInfo")
//            }
//        }
//
//    }
//
//    private func showPurcheseButton(){
//        Purchases.shared.offerings { [self] (offerings, error) in
//            if let error = error {
//                debugPrint("ERROR")
//                debugPrint(error.localizedDescription)
//                return
//            }
//            if let offerings = offerings {
//                debugPrint(offerings.current?.availablePackages as Any)
//
//                offerings.current?.availablePackages.forEach({ package in
//                    viewModel.model.append(PricingModel(title: package.product.localizedTitle,
//                                                        text: package.product.localizedDescription,
//                                                        price: package.localizedPriceString,
//                                                        package: package))
//
//                })
//                table.reloadData()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.model.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PricingCell
//        let model = viewModel.model[indexPath.row]
//        cell.setup(price: model.price, title: model.title, text: model.text)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedPackage = viewModel.model[indexPath.row].package
//        let cell = (tableView.cellForRow(at: indexPath) as! PricingCell)
//        cell.select()
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = (tableView.cellForRow(at: indexPath) as! PricingCell)
//        cell.deselect()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//
//}
//
//struct PricingModel {
//    var title: String
//    var text: String
//    var price: String
//    var package: Purchases.Package
//}
//
//class PricingCell: UITableViewCell {
//    public var content: UIView = UIView()
//    private var title: Text = Text(.article, .label)
//
//    private var selectedIcon: UIImageView = UIImageView(image: Icons.checkmark.image())
//    private var article: Text = Text(.regular, .label)
//    public var onPress: ()->() = {}
//    public var onSubscribe: ()->() = {}
//
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupDesign()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupDesign() {
//        backgroundColor = .clear
//        selectionStyle = .none
//        addSubview(content)
//        content.layer.cornerRadius = 25
//        content.backgroundColor = .systemGray6
//        content.easy.layout(Leading(20),Trailing(20),Top(4),Bottom(4))
//
//        content.addSubview(title)
//        content.addSubview(article)
//        content.addSubview(selectedIcon)
//
//        title.easy.layout(Leading(20), Trailing(20), Top(13))
//        title.numberOfLines = 1
//
//        article.easy.layout(Leading(20), Trailing(20), Top().to(title))
//        article.numberOfLines = 2
//
//        selectedIcon.easy.layout(Trailing(20),CenterY())
//        selectedIcon.tintColor = UIColor.systemIndigo
//        selectedIcon.alpha = 0
//    }
//
//    public func setup(price: String, title: String, text: String){
//        article.text = "\(price) / \(text)"
//        self.title.text = title
//        article.sizeToFit()
//    }
//
//    func select() {
//        UIView.animate(withDuration: 0.3) {
//            self.content.backgroundColor = .systemGray5
//            self.content.layer.borderWidth = 2
//            self.content.layer.borderColor = UIColor.systemIndigo.cgColor
//            self.selectedIcon.alpha = 1
//        }
//    }
//
//
//    func deselect() {
//        UIView.animate(withDuration: 0.3) {
//            self.content.backgroundColor = .systemGray6
//            self.content.layer.borderWidth = 0
//            self.content.layer.borderColor = UIColor.clear.cgColor
//            self.selectedIcon.alpha = 0
//        }
//    }
//}
//
