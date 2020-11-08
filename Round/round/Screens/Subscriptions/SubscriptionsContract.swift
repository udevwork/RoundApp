//
//  SubscriptionsContract.swift
//  round
//
//  Created by Denis Kotelnikov on 06.04.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class SubscriptionsContract {
    
}

enum SubscriptionsCellTypes {
    case Title(SubscriptionsCellTextModel)
    case Benefit(SubscriptionsCellTextModel)
    case Terms(SubscriptionsCellTermsModel)
    case Info(SubscriptionsCellTextModel)
}

struct SubscriptionsCellTextModel {
    var text: String
}

struct SubscriptionsCellTermsModel {
    var onTermspress: ()->()
    var onPrivacypress: ()->()
}

