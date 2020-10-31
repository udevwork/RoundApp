//
//  LocalizationManager.swift
//  round
//
//  Created by Denis Kotelnikov on 05.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

enum LocalizationKeys : String {
    case icons = "icons"
    case subs = "subscription"
    case howto = "how_to"
    case settings = "settings"
    
    case subscribe = "subscribe";
    case subDescription = "subDescription"
    
    case title_1 = "1title"
    case article_1 = "1article"
    case title_2 = "2title"
    case article_2 = "2article"
    case title_3 = "3title"
    case article_3 = "3article"
    case title_4 = "4title"
    case article_4 = "4article"
    case title_5 = "5title"
    case article_5 = "5article"
    case title_6 = "6title"
    case article_6 = "6article"
    case title_7 = "7title"
    case article_7 = "7article"
    case title_8 = "8title"
    case article_8 = "8article"
    case title_9 = "9title"
    case article_9 = "9article"
    case title_10 = "10title"
    case article_10 = "10article"
    case title_11 = "11title"
    case article_11 = "11article"
    case title_12 = "12title"
    case article_12 = "12article"
    case title_13 = "13title"
    case article_13 = "13article"
    
    case policy = "policy"
    case termsOfUse = "termsOfUse"
    case сontactUs = "сontactUs"
    case subscriptionTerms = "subscriptionTerms"
    case restore = "restore"
    
    case unlocked = "unlocked"
    case purchaseError = "purchaseError"
    case purchaseRestore = "purchaseRestore"
    case purchaseRestoreError = "purchaseRestoreError"
    case archiveSaveError = "archiveSaveError"
    case unzipError = "unzipError"
    case tempClearError = "tempClearError"
    case emailCopyed = "emailCopyed"
    case saved = "saved"
    
    case download = "download"
    case buy = "buy"
    case downloadind = "downloadind"
    case unzipping = "unzipping"
    case packnotavailable = "packnotavailable"
    case comingsoon = "comingsoon"
    case morenew = "morenew"
    
    case postsLoadingTitle = "postsLoadingTitle"
    case postsLoadingSubtitle = "postsLoadingSubtitle"
    case back = "back"
    
    func localized() -> String {
        return self.rawValue.localized()
    }
}

func localized(_ localization: LocalizationKeys) -> String {
    return localization.rawValue.localized()
}

func regionTable() -> String {
    switch Locale.current.languageCode ?? "en" {
    case "en":
        return "en"
    case "ru":
        return "ru"
    default:
        return "en"
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: regionTable(),
                                 bundle: .main,
                                 value: String(self),
                                 comment: "")
    }
}

