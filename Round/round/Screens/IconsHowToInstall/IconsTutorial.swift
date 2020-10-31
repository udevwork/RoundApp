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
        howToModel(title: localized(.title_1), imageName: "1", text: localized(.article_1)),
        howToModel(title: localized(.title_2),imageName: "2", text: localized(.article_2)),
        howToModel(title: localized(.title_3),imageName: "3", text: localized(.article_3)),
        howToModel(title: localized(.title_4),imageName: "4", text: localized(.article_4)),
        howToModel(title: localized(.title_5),imageName: "5", text: localized(.article_5)),
        howToModel(title: localized(.title_6),imageName: "6", text: localized(.article_6)),
        howToModel(title: localized(.title_7),imageName: "7", text: localized(.article_7)),
        howToModel(title: localized(.title_8),imageName: "8", text: localized(.article_8)),
        howToModel(title: localized(.title_9),imageName: "9", text: localized(.article_9)),
        howToModel(title: localized(.title_10),imageName: "10", text: localized(.article_10)),
        howToModel(title: localized(.title_11),imageName: "11", text: localized(.article_11)),
        howToModel(title: localized(.title_12),imageName: "12", text: localized(.article_12)),
        howToModel(title: localized(.title_13),imageName: "13", text: localized(.article_13))
    ]
}

class IconsTutorial: BaseViewController<IconsTutorialModel>, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let header: TitleHeader = TitleHeader()
    
    let cellWidth =   UIScreen.main.bounds.width
    let cellHeight =  UIScreen.main.bounds.height - 300
    
    fileprivate lazy var collectionView : GeminiCollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.minimumLineSpacing = -50
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let collection = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.layer.masksToBounds = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = UIScrollView.DecelerationRate.fast
        collection.isScrollEnabled = true
        collection.backgroundColor = .clear
        return collection
    }()
    
    override init(viewModel: IconsTutorialModel) {
        super.init(viewModel: viewModel)
        view.insetsLayoutMarginsFromSafeArea = true
        
        view.addSubview(collectionView)
        view.addSubview(header)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(howToCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.gemini
            .customAnimation()
            .alpha(0.01)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header.text = localized(.howto)
        header.easy.layout(Top(Design.safeArea.top + 10),Leading(),Trailing(),Height(40))
        collectionView.easy.layout(Trailing(), Leading(), CenterY(25), Height(cellHeight))
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
        return .zero
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
        content.easy.layout(Width(UIScreen.main.bounds.width - 60), CenterY(), CenterX())
        
        content.addSubview(title)
        content.addSubview(screenshot)
        content.addSubview(article)
        
        title.easy.layout(Leading(20), Trailing(20), Top(20))
        title.numberOfLines = 1
        title.textAlignment = .center
        
        screenshot.easy.layout(Top(20).to(title), Leading(20), Trailing(20), Height(UIScreen.main.bounds.width - 100))
        screenshot.contentMode = .scaleAspectFill
        screenshot.layer.cornerRadius = 15
        screenshot.layer.masksToBounds = true
        
        article.easy.layout(Leading(20), Trailing(20), Top(20).to(screenshot), Bottom(20))
        article.numberOfLines = 2
        article.textAlignment = .center
    }
    
    public func setup(title: String,image: UIImage, text: String){
        screenshot.image = image
        article.text = text
        self.title.text = title
        article.sizeToFit()
    }
}

class TitleHeader: UIView {
    
    private let title: Text = Text(.title, .label)
    private let delimiter: UIView = UIView()
    
    var text: String = "" {
        didSet{
            self.title.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDesign(){
        backgroundColor = .clear
        addSubview(title)
        title.easy.layout(Leading(20), CenterY())
        
        addSubview(delimiter)
        delimiter.easy.layout(Bottom(), Leading(20), Trailing(20), Height(1))
        delimiter.backgroundColor = .systemGray2
        
    }
    
}

struct howToModel {
    var title: String
    var imageName: String
    var text: String
}
