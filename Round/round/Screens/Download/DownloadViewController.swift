//
//  DownloadViewController.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

struct DownloadViewControllerModel {
    var link: String
    var downloadbleImage: UIImage
    var downloadbleName: String
}

class DownloadViewController: UIViewController{
    
    private var content: UIView = UIView()
    private var image: UIImageView = UIImageView()
    private var text: Text = Text(.regular, .label)
    
    private var model: DownloadViewControllerModel
    init(model: DownloadViewControllerModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        setupDesign()
    }
    
    private func setupDesign(){
        modalPresentationStyle = .popover
        view.backgroundColor = .clear
        view.addSubview(content)
        content.layer.cornerRadius = 15
        content.backgroundColor = .systemGray6
        content.easy.layout(Bottom(20), Leading(20), Trailing(20), Height(400))
        
        image.image = model.downloadbleImage
        content.addSubview(image)
        image.easy.layout(Size(200), CenterX(), CenterY(-20))
        image.layer.cornerRadius = 15
        image.layer.borderWidth = 6
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        
        text.text = model.downloadbleName
        content.addSubview(text)
        text.easy.layout(Top(10).to(image), CenterX())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        download()
    }
    func download() {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/roundapp-4d7d3.appspot.com/o/fuck.png?alt=media&token=20e45ff6-e8f1-4e56-91b1-ddd85a531e1d")
        FileDownloader.loadFileAsync(url: url!) { (data, error) in
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
        } status: { status in
            DispatchQueue.main.async {
                self.text.text = status
            }
        }
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
