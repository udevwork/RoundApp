//
//  IAPManager.swift
//  round
//
//  Created by Denis Kotelnikov on 10.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    private override init() {}
    
    private var onGetPackPrice: ((SKProduct?)->())?
    private var onPurchasingComplete: ((Bool)->())?
    private var productID: String?
    private var payment: SKPayment? = nil

    public func getPackPrice(ID: String,complition: @escaping (SKProduct?)->()) {
        self.onGetPackPrice = complition
        self.productID = ID
        let request = SKProductsRequest(productIdentifiers: [ID])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products.first?.price as Any)
        print(response.products.first?.localizedTitle as Any)
        if response.products.count > 0, let product = response.products.first {
            DispatchQueue.main.async {
                self.onGetPackPrice?(product) // can be nil
            }
            self.payment = SKPayment(product: product)
        } else {
            print(response.products.first as Any)
            DispatchQueue.main.async {
                self.onGetPackPrice?(nil) // can be nil
            }
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transact in
            switch transact.transactionState {
            case .purchasing:
                debugPrint("purchasing")
            case .purchased:
                debugPrint("purchased")
                SKPaymentQueue.default().finishTransaction(transact)
                if let ID = productID {
                    ProductManager().save(productID: ID)
                }
                DispatchQueue.main.async {
                    self.onPurchasingComplete?(true)
                }
            case .failed:
                debugPrint("failed")
                DispatchQueue.main.async {
                    self.onPurchasingComplete?(false)
                }
            case .restored:
                debugPrint("restored")
            case .deferred:
                debugPrint("deferred")
            @unknown default:
                debugPrint("error")
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            let prodID = t.payment.productIdentifier as String
            debugPrint("RestoredID: ", prodID)
            ProductManager().save(productID: prodID)
            
        }
        onPurchasingComplete?(true)
    }
    
    
    func purchase(complition: @escaping (Bool)->()) {
        self.onPurchasingComplete = complition
        if let payment = payment {
            SKPaymentQueue.default().add(payment)
        } else {
            debugPrint("no payment!")
        }
    }
    
    func restore(complition: @escaping (Bool)->()) {
        self.onPurchasingComplete = complition
        SKPaymentQueue.default().restoreCompletedTransactions()
        debugPrint("Start restore")
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
}

extension SKProduct {
    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }

    var localizedPrice: String {
        if self.price == 0.00 {
            return "free"
        } else {
            let formatter = SKProduct.formatter
            formatter.locale = self.priceLocale

            guard let formattedPrice = formatter.string(from: self.price) else {
                return "Unknown Price"
            }

            return formattedPrice
        }
    }
}


//                Purchases.shared.purchaserInfo { (purchaserInfo, error) in
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//                    if let info = purchaserInfo {
//                        if info.entitlements["IDesignerSubscriber"]?.isActive == true {
//                            let model = DownloadViewModel.Model(link: link,
//                                                                downloadbleImage: self.header!.backgroundImageView.image!,
//                                                                downloadbleName: self.header!.bottomTextBlockView.titleLabel.text!,
//                                                                downloadbleDescription: self.header!.bottomTextBlockView.descriptionLabel.text!)
//                            let vc = DownloadViewController(model: model)
//                            self.present(vc, animated: true, completion: nil)
//                            FirebaseAPI.shared.incrementPostDownloadCounter(post: self.viewModel.cardView.viewModel?.id ?? "")
//                        } else {
//                            debugPrint("IDesignerSubscriber in diactivated!")
//                            let vc = SubscriptionsRouter.assembly(model: SubscriptionsViewModel())
//                            self.present(vc, animated: true, completion: nil)
//                        }
//                    } else {
//                        debugPrint("no purchaserInfo")
//                    }
//
//                }
