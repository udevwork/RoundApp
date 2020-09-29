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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.download()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    func download() {
        let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("fuck: ", savePath)
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/roundapp-4d7d3.appspot.com/o/images.zip?alt=media&token=a5027027-a2c1-49b9-aece-09ee0ca89460")
        FileDownloader.loadFileAsync(url: url!) { (data, error) in
            do {
                try data?.write(to: savePath.appendingPathComponent("archive.zip"))
            } catch let err{
                print("FUCK ERROR WRITE: ", err)
            }
            
            print("FUCK WRITE OK")
            
            do {
                try FileManager.default.unzipItem(at: savePath.appendingPathComponent("archive.zip"), to: savePath)
            } catch let err {
                print("FUCK ERROR unzipItem: ", err)
            }
            print("FUCK unzipItem OK")
            
            do {
                let lol = try FileManager.default.contentsOfDirectory(at: savePath.appendingPathComponent("images"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                var resuptImages: [Data] = []
                lol.forEach { imageUrl in
                    print("fuck image! : ", imageUrl.path)
                    let imgData = FileManager.default.contents(atPath: imageUrl.path)
                    resuptImages.append(imgData!)
                }
                DispatchQueue.main.async {
                    let activityViewController = UIActivityViewController(activityItems: resuptImages, applicationActivities: nil)
                    activityViewController.completionWithItemsHandler  = { type, success, items, error in
                        if success {
                            // Deleting files
                            do {
                                let lol = try FileManager.default.contentsOfDirectory(at: savePath, includingPropertiesForKeys: nil, options: [])
                                
                                 lol.forEach { urlToRemove in
                                    do {
                                     try FileManager.default.removeItem(at: urlToRemove)
                                    } catch {
                                        print("Could not delete file \(error)")
                                    }
                                }
                                
                            } catch {
                                print("Could not clear temp folder: \(error)")
                            }
                        }
                    }
                    self.present(activityViewController, animated: true, completion: {
                        print("COMPLITION")
                    })
                }
                // process files
            } catch let err {
                print("FUCK ERROR contentsOfDirectory: ", err)
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
