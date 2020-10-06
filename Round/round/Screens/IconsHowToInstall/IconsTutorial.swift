//
//  IconsTutorial.swift
//  round
//
//  Created by Denis Kotelnikov on 05.10.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Gemini

class IconsTutorialRouter {
    static func assembly() -> UIViewController{
        return IconsTutorial(viewModel: IconsTutorialModel())
    }
}

class IconsTutorialModel {
    let model: [howToModel] = [
        howToModel(title: "1. open shortcats", imageName: "1", text: "1) Add space between table rows swift space between table cells"),
        howToModel(title: "2. open shortcats",imageName: "2", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "3. open shortcats",imageName: "3", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "4. open shortcats",imageName: "4", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "5. open shortcats",imageName: "5", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "6. open shortcats",imageName: "6", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "7. open shortcats",imageName: "7", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "8. open shortcats",imageName: "8", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "9. open shortcats",imageName: "9", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "10. open shortcats",imageName: "10", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "11. open shortcats",imageName: "11", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "12. open shortcats",imageName: "12", text: "2) swift sadd spacing between tableview cells swift"),
        howToModel(title: "13. open shortcats",imageName: "13", text: "2) swift sadd spacing between tableview cells swift"),
    ]
}

class IconsTutorial: BaseViewController<IconsTutorialModel>, UICollectionViewDelegate, UICollectionViewDataSource {
  
    let header: howToHeader = howToHeader()
    
    let cellWidth =   UIScreen.main.bounds.width
    let cellHeight =  UIScreen.main.bounds.height - 150
    
    fileprivate lazy var collectionView : GeminiCollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        let collection = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.isScrollEnabled = true
        return collection
    }()
    
    override init(viewModel: IconsTutorialModel) {
        super.init(viewModel: viewModel)
        view.addSubview(collectionView)
        view.addSubview(header)
        collectionView.delegate = self
        collectionView.dataSource = self
        let bottom = Design.safeArea.bottom + 150
        let top = Design.safeArea.top + 100
        collectionView.easy.layout(Trailing(),Leading(),Bottom(bottom),Top(top))
        collectionView.register(howToCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.gemini
            .customAnimation()
            .alpha(0.01)
            .rotationAngle(x: 0, y: 0, z: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! howToCell
        let model = viewModel.model[indexPath.row]
        cell.setup(title: model.title, image: UIImage(named: model.imageName)!, text: model.text)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if let cell = cell as? GeminiCell {
             self.collectionView.animateCell(cell)
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gallery = PagerMediaViewerRouter.assembly(selectedPhotoIndex: indexPath.row, delegateGallery: self)
        
        present(gallery, animated: true, completion: nil)
    }
    
    var hiddenCell: UIView? = nil

}

extension IconsTutorial: GalleryPagerMediaViewerDelegateProtocol {
    func pagerMedia(closed: PagerMediaViewer) {
        hiddenCell?.isHidden = false
    }
    
    func pagerMedia(frameOfImageInCell id: Int) -> CGRect? {
        
        if let cell = (collectionView.cellForItem(at: IndexPath(row: id, section: 0)) as? howToCell ) {
            hiddenCell?.isHidden = false
            hiddenCell = cell
            hiddenCell?.isHidden = true
            let selectedFrame = cell.convert(cell.screenshot.frame, to: nil)
            return selectedFrame
        } else {
            hiddenCell?.isHidden = false
            return .zero
        }
    }
    
    func pagerMedia(imageOfInDataSource id: Int) -> UIImage? {
        return UIImage(named: viewModel.model[id].imageName)!
    }
    
    func pagerMedia(ImagesCountFor: PagerMediaViewer) -> Int {
        return viewModel.model.count
    }
    
    
}


class howToCell: GeminiCell {
    public var content: UIView = UIView()
    private var title: Text = Text(.title, .label)

    public var screenshot: UIImageView = UIImageView()
    private var article: Text = Text(.article, .label)
    public var onPress: ()->() = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign() {
        backgroundColor = .clear
        addSubview(content)
        content.layer.cornerRadius = 25
        content.backgroundColor = .systemGray6
        content.easy.layout(Leading(20),Trailing(20),Top(10),Bottom(10))
        content.setupShadow(preset: .Post)
        
        content.addSubview(title)
        content.addSubview(screenshot)
        content.addSubview(article)

        title.easy.layout(Leading(20), Trailing(20), Top(20))
        title.numberOfLines = 1
        title.textAlignment = .center
        
        screenshot.easy.layout(CenterX(), Top(70), Bottom(110))
        screenshot.contentMode = .scaleAspectFit
        
        article.easy.layout(Leading(20), Trailing(20), Bottom(20))
        article.numberOfLines = 3
        article.textAlignment = .center
    }

    public func setup(title: String,image: UIImage, text: String){
        screenshot.image = image
        article.text = text
        self.title.text = title
        article.sizeToFit()
    }
}

class howToHeader: UIView {
  
    var Title: Text = Text(.title, .label)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign(){
        backgroundColor = .clear
        addSubview(Title)
        Title.easy.layout(Leading(20), Trailing(20), Top(20), Bottom(20))
    }
    
}

struct howToModel {
    var title: String
    var imageName: String
    var text: String
}
