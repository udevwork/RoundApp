//
//  SignInViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import Purchases

class SubscriptionsViewModel: BaseViewModel {
    var router: SubscriptionsRouter?

    typealias routerType = SubscriptionsRouter
    
    static var userSubscibed: Bool = false
    static var package: Purchases.Package? = nil
    
    var model: [SubscriptionsCellTypes] = []
    
    init() {
        model.append(contentsOf: [
            .Title(SubscriptionsCellTextModel(text: localized(.subDescription))),
            .Benefit(SubscriptionsCellTextModel(text: localized(.subone))),
            .Benefit(SubscriptionsCellTextModel(text: localized(.subtwo))),
            .Benefit(SubscriptionsCellTextModel(text: localized(.subthree))),
            .Benefit(SubscriptionsCellTextModel(text: localized(.subfour))),
            .Terms(SubscriptionsCellTermsModel(
                    onTermspress: {
                        self.router?.showTerms()
                    },
                    onPrivacypress: {
                        self.router?.showPrivacy()
                    })),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfoone))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfotwo))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfothree))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfofour))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfofive))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfosix))),
            .Info(SubscriptionsCellTextModel(text: localized(.subinfoseven)))
        ])
    }
    
    static func checkIfUserSubscribed() {
        DispatchQueue.main.async {
            Purchases.shared.purchaserInfo { (purchaserInfo, error) in
                if let error = error {
                    debugPrint("Purchases: ", error)
                    return
                }
                if let info = purchaserInfo {
                    if info.entitlements["idesignerprouser"]?.isActive == true {
                        SubscriptionsViewModel.userSubscibed = true
                    } else {
                        SubscriptionsViewModel.getOffer()
                    }
                } else {
                    debugPrint("no purchaserInfo")
                }
            }
        }
    }
    
    private static func getOffer(){
        Purchases.shared.offerings { offerings, error in
            if let error = error {
                debugPrint("Purchases: ERROR")
                debugPrint(error.localizedDescription)
                return
            }
            if let offerings = offerings {
                debugPrint("Purchases: ", offerings.current?.availablePackages as Any)
                SubscriptionsViewModel.package = offerings.current?.availablePackages.first
            }
        }
    }
}
