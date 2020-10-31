//  Created by Denis Kotelnikov on 10.09.2020.
//  Copyright © 2020 Round. All rights reserved.

import Foundation
import UIKit
import EasyPeasy
import Kingfisher

struct PagerMediaItemData {
    var model: UIImage
    var index: Int
}

public class PagerMediaViewer: UIPageViewController, UIGestureRecognizerDelegate {
    
    private let viewModel: PagerMediaViewerViewModel
    
    /// current page index
    private var currentIndex: Int = 0
    private var currentPage: PagerMediaViewerImagePage? = nil
    public var imgOriginalFrame: CGRect? = nil
    public var closeAnimator = PagerMediaCloseTransition()
    public weak var delegateGallery: GalleryPagerMediaViewerDelegateProtocol?
    /// in fact, this is the number of photos or videos.
    /// In order not to count the number of photos each time we use this variable
    private var maxIndex: Int = 0
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(with viewModel: PagerMediaViewerViewModel) {
        self.viewModel = viewModel
        
        let pageOptions = [UIPageViewController.OptionsKey.interPageSpacing: 20]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: pageOptions)
        
        modalPresentationStyle = .overFullScreen

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        transitioningDelegate = self
        currentIndex = viewModel.selectedPhotoIndexPath.row
        maxIndex = delegateGallery?.pagerMedia(ImagesCountFor: self) ?? 0
        
        // setupStartPage
        currentPage = (generateViewController(index: currentIndex) as! PagerMediaViewerImagePage)
        if let imageView = currentPage?.targetView {
            closeAnimator.img.image = imageView.image
            closeAnimator.imgToFrame = imgOriginalFrame
        }
        setViewControllers([(currentPage!)], direction: .forward, animated: true, completion: nil)
        setupLayout()
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        delegateGallery?.pagerMedia(closed: self)
    }
    
    // MARK: Layout
    private func setupLayout(){
        view.backgroundColor = .black
    }
    
    
    // только тут нужно делать все необходимое с ячейками
    private func generateViewController(index: Int) -> UIViewController {
        let data = PagerMediaItemData(model: delegateGallery!.pagerMedia(imageOfInDataSource: index)!, index: index)
        var controllerToShow: PagerMediaItemProtocol
        
        controllerToShow = PagerMediaViewerImagePage()
        currentPage = controllerToShow as? PagerMediaViewerImagePage
        
        debugPrint("current page was setted")
        controllerToShow.delegate = self
        controllerToShow.setup(data: data)
        return controllerToShow as! UIViewController
    }
    
    
    deinit {
        
    }
}

extension PagerMediaViewer: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? PagerMediaItemBaseLogic else { return nil }
        guard let index = vc.data?.index, index > 0 else { return nil }
        
        let newIndex = index - 1
        
        return generateViewController(index: newIndex)
    }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? PagerMediaItemBaseLogic else { return nil }
        guard let index = vc.data?.index, index <= (maxIndex - 2) else { return nil }
        
        let newIndex = index + 1
        
        return generateViewController(index: newIndex)
    }
    
    // MARK: Animation finish
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let page = (pageViewController.viewControllers?.first as! PagerMediaViewerImagePage)
        currentIndex = page.data?.index ?? 0
        viewModel.selectedPhotoIndexPath = IndexPath(row: currentIndex, section: 0)
        let img = delegateGallery?.pagerMedia(imageOfInDataSource: currentIndex)
        closeAnimator.img.image = img
        
        currentPage = pageViewController.viewControllers![0] as? PagerMediaViewerImagePage
        debugPrint("PagerMediaViewer: current page was setted")
        
        closeAnimator.imgFromFrame = currentPage?.getImageOriginalFrame()
        debugPrint("PagerMediaViewer: index: ", currentIndex)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        debugPrint("PagerMediaViewer: willTransitionTo", pendingViewControllers)
    }
    
}

// Used for page communication with pageController
extension PagerMediaViewer : PagerMediaViewerDelegateProtocol {
    
    func pagerMediaItemPan(state: PagerMediaItemBaseLogic.ItemPanStatus) {
        switch state {
        case .start:
            break
        case .cancel:
            break
        case .dismis:
            viewModel.close()
        case .move(let convertedFrame):
            closeAnimator.imgFromFrame = convertedFrame
            break
        }
    }
    
}

extension PagerMediaViewer : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if delegateGallery == nil { return nil }
        var img: UIImage = UIImage()
        if let _i = delegateGallery?.pagerMedia(imageOfInDataSource: currentIndex) {
            img = _i
        }
        let frame = currentPage?.targetView.frame
        let original = delegateGallery?.pagerMedia(frameOfImageInCell: currentIndex)
        return PagerMediaOpenTransition(img: img, imgFromFrame: original!, imgToFrame: frame!)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if delegateGallery == nil { return nil }
        
        let original = delegateGallery?.pagerMedia(frameOfImageInCell: currentIndex)
        self.closeAnimator.imgFromFrame = currentPage!.getImageOriginalFrame()
        
        debugPrint("PagerMediaViewer close anima frame: ", currentPage!.convertTargetViewFrame())
        closeAnimator.imgToFrame = original
        return closeAnimator
    }
    
}
