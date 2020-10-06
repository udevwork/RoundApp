//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit

public class PagerMediaViewerRouter {
    
    weak var view: PagerMediaViewer?
    
    static public func assembly(selectedPhotoIndex: Int, delegateGallery: GalleryPagerMediaViewerDelegateProtocol?) -> UIViewController {
        
        let router = PagerMediaViewerRouter()
        
        let model = PagerMediaViewerViewModel(router: router, selectedPhotoIndex: selectedPhotoIndex)
        
        let vc = PagerMediaViewer(with: model)
        vc.delegateGallery = delegateGallery
        router.view = vc
        guard let view = router.view else {
            fatalError("cannot instantiate \(String(describing: PagerMediaViewer.self))")
        }
        return view
    }
    
    public func dissmis() {
        view?.dismiss(animated: true, completion: nil)
    }
    
}
