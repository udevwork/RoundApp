//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

protocol PagerMediaItemProtocol {
    func setup(data: PagerMediaItemData)
    var delegate: PagerMediaViewerDelegateProtocol? { get set }
}
