//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Kingfisher
import UIKit

// MARK: Page with image in gallery
class PagerMediaViewerImagePage: PagerMediaItemBaseLogic, PagerMediaItemProtocol {
    func setup(data: PagerMediaItemData) {
        self.data = data
        targetView.image = data.model
    }
}
