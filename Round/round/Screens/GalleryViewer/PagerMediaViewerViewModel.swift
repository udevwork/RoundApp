//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit

public class PagerMediaViewerViewModel {
    
    public required init(router: PagerMediaViewerRouter, selectedPhotoIndex: Int) {
        self.router = router
        self.selectedPhotoIndexPath = IndexPath(row: selectedPhotoIndex, section: 0)
    }
    
    public var selectedPhotoIndexPath: IndexPath

    public func close() {
        router.dissmis()
    }
 
    private let router: PagerMediaViewerRouter
}
