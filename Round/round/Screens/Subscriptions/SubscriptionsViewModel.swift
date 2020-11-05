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
