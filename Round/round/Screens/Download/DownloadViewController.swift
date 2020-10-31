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
import ZIPFoundation


class DownloadViewController: UIViewController {
    
    private var drugtumbler: UIView = UIView()
    private var content: UIView = UIView()
    private var delimiter: UIView = UIView()
    private var image: UIImageView = UIImageView()
    private var assetNametext: Text = Text(.title, .label)
    private var assetDescriptiontext: Text = Text(.system, .label)
    private var progressText: Text = Text(.system, .label)
    private var progbar: UIProgressView = UIProgressView(progressViewStyle: .bar)
    
    private let viewModel: DownloadViewModel
    
    init(model: DownloadViewModel.Model) {
        viewModel = DownloadViewModel(model: model)
        super.init(nibName: nil, bundle: nil)
        setupDesign()
    }
    
    private func setupDesign(){
        modalPresentationStyle = .popover
        view.backgroundColor = .clear
        view.addSubview(content)
        content.layer.cornerRadius = 25
        content.backgroundColor = .systemGray6
        content.easy.layout(Bottom(5 + Design.safeArea.bottom), Leading(5), Trailing(5), Height(400))
        content.setupShadow(preset: .medium)
        
        view.addSubview(drugtumbler)
        drugtumbler.layer.cornerRadius = 3
        drugtumbler.backgroundColor = .systemGray
        drugtumbler.easy.layout(Bottom(6).to(content, .top), Width(50), Height(6), CenterX())
        
        image.image = viewModel.model.downloadbleImage
        content.addSubview(image)
        image.easy.layout(Leading(20), Trailing(20), Top(20), Height(220))
        image.layer.cornerRadius = 20
        image.layer.borderWidth = 6
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        
        assetNametext.text = viewModel.model.downloadbleName
        content.addSubview(assetNametext)
        assetNametext.easy.layout(Leading(40), Trailing(40), Top(20).to(image))
        
        assetDescriptiontext.text = viewModel.model.downloadbleDescription
        content.addSubview(assetDescriptiontext)
        assetDescriptiontext.easy.layout(Leading(40), Trailing(40), Top(5).to(assetNametext))
        assetDescriptiontext.numberOfLines = 2
        
        content.addSubview(delimiter)
        delimiter.easy.layout(Leading(40), Trailing(40), Top(20).to(assetDescriptiontext), Height(1))
        delimiter.backgroundColor = .systemGray3
        
        content.addSubview(progressText)
        progressText.easy.layout(Leading(40), Top(20).to(delimiter), CenterX())
 
        content.addSubview(progbar)
        progbar.easy.layout(Width(100), Trailing(40), CenterY().to(progressText), Height(5))
        progbar.layer.cornerRadius = 2.5
        progbar.layer.masksToBounds = true
        progbar.progressTintColor = .systemGray
        progbar.trackTintColor = .systemGray4
        progbar.isHidden = true
        
        viewModel.onProgress = { progress in
            self.progbar.setProgress(progress, animated: true)
        }
        viewModel.onStatus = { status in
            self.progbar.isHidden = false
            self.progbar.setProgress(0, animated: false)
            self.progressText.text = status
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.download { images in
                self.showSaveToFilesMenu(data: images)
            }
        }
    }
    
    func showSaveToFilesMenu(data: [Data]) {
        let activityViewController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        activityViewController.completionWithItemsHandler  = { type, success, items, error in
            if success {
                self.viewModel.deleteFilesInWorkindDir()
                self.dismiss(animated: true) {
                    Notifications.shared.Show(RNSimpleView(text: localized(.saved), icon: Icons.download.image(), iconColor: .systemGreen))
                }
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
