//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit

public protocol GalleryPagerMediaViewerDelegateProtocol: AnyObject {
    func pagerMedia(frameOfImageInCell id: Int) -> CGRect?
    func pagerMedia(imageOfInDataSource id: Int) -> UIImage?
    func pagerMedia(ImagesCountFor: PagerMediaViewer) -> Int
    func pagerMedia(closed pages: PagerMediaViewer)
}

protocol PagerMediaViewerDelegateProtocol: AnyObject {
    func pagerMediaItemPan(state: PagerMediaItemBaseLogic.ItemPanStatus) // call when user user pan image
}
