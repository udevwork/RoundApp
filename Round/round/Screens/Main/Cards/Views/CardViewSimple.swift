//
//  CardViewSimple.swift
//  round
//
//  Created by Denis Kotelnikov on 08.06.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import EasyPeasy

class CardViewSimple: CardView {
    override func setupData(_ viewModel: CardViewModel?) {
        actionButton.removeFromSuperview()
        backgroundImageView.image = Images.postLoadingTemplate.uiimage()
        downloadsCounterView.setIcon(.info)
        downloadsCounterView.setText("...")
        bottomTextBlockView.set(localized(.comingsoon), localized(.morenew))
    }
}
