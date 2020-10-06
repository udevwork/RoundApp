//
//  LocalizationManager.swift
//  round
//
//  Created by Denis Kotelnikov on 05.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: Locale.current.regionCode ?? "EN",
                                 bundle: .main,
                                 value: String(self),
                                 comment: "")
    }
}

