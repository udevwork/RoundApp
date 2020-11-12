//
//  DownloadViewModel.swift
//  round
//
//  Created by Denis Kotelnikov on 30.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import UIKit
import ZIPFoundation


class DownloadViewModel {
    
    struct Model {
        var link: String
        var downloadbleImage: UIImage
        var downloadbleName: String
        var downloadbleDescription: String
    }
    
    public let model: DownloadViewModel.Model
    private var observation: NSKeyValueObservation?
    public var onProgress: ((Float)->())!
    public var onStatus: ((String)->())!
    
    init(model: DownloadViewModel.Model) {
        self.model = model
    }
    
    let originPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("icons")
    let originArcivesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("icons").appendingPathComponent("archives")
    let originimagesTempPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("icons").appendingPathComponent("temp")
    let originimagesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("icons").appendingPathComponent("savedImages")

    
    func download(completion: @escaping ([Data])->()) {
        guard let url = URL(string: self.model.link) else {
            return
        }
        
        var isDir : ObjCBool = true
        let exist = FileManager.default.fileExists(atPath: originPath.absoluteString, isDirectory: &isDir)
        
        if exist == false {
            do {
                try FileManager.default.createDirectory(at: originPath, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: originArcivesPath, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: originimagesTempPath, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.createDirectory(at: originimagesPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("creation directorry error: ", error)
            }
        }
        
        deleteFilesInWorkindDir()
        
        downloadZip(url: url) { [self] (data, error) in
            // save zip
            do {
                let path = originArcivesPath.appendingPathComponent("\(model.downloadbleName).zip")
                try data?.write(to: path)
                DispatchQueue.main.async {
                    let imageToSavePath = originimagesPath.appendingPathComponent("\(model.downloadbleName.removingWhitespaces()).jpeg")
                    if let data = model.downloadbleImage.jpegData(compressionQuality: 3) {
                          do {
                            try data.write(to: imageToSavePath)
                              print("Successfully saved image at path: \(originimagesPath)")
                          } catch {
                              print("Error saving image: \(error)")
                          }
                      }
                    
                    ProductManager().save(archiveLocalPath: model.downloadbleName, imageLocalPath: "\(model.downloadbleName.removingWhitespaces()).jpeg", archiveName: model.downloadbleName, archiveDescription: model.downloadbleDescription)
                    print("image local save: ", imageToSavePath.absoluteString)

                }
            } catch let err {
                debugPrint("FUCK ERROR WRITE: ", err)
                Notifications.shared.Show(RNSimpleView(text: localized(.archiveSaveError), icon: Icons.cross.image(), iconColor: .systemRed))
            }
            
            debugPrint("FUCK WRITE OK")
            
            unzip(completion: completion)
        }
    }
    
    public func deleteFilesInWorkindDir(){
        // Deleting files
        do {
            let lol = try FileManager.default.contentsOfDirectory(at: originimagesTempPath, includingPropertiesForKeys: nil, options: [])
            
            lol.forEach { urlToRemove in
                do {
                    try FileManager.default.removeItem(at: urlToRemove)
                } catch {
                    debugPrint("Could not delete file \(error)")
                    Notifications.shared.Show(RNSimpleView(text: localized(.tempClearError), icon: Icons.cross.image(), iconColor: .systemRed))
                }
            }
        } catch {
            Notifications.shared.Show(RNSimpleView(text: localized(.tempClearError), icon: Icons.cross.image(), iconColor: .systemRed))
            debugPrint("Could not clear temp folder: \(error)")
        }
    }
    
    private func downloadZip(url: URL, completion: @escaping (Data?, Error?)->()) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        DispatchQueue.main.async {
            self.onStatus(localized(.downloadind))
        }
        let completionHandler: (Data?, URLResponse?, Error?)->() = { data, response, error in
            if error == nil
            {
                if let response = response as? HTTPURLResponse
                {
                    if response.statusCode == 200
                    {
                        if let data = data
                        {
                            completion(data, error)
                        }
                        else
                        {
                            completion(nil, error)
                        }
                    }
                }
            }
            else
            {
                completion(nil, error)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        observation = task.progress.observe(\.fractionCompleted) { progress, _ in
            DispatchQueue.main.async {
                self.onProgress(Float(progress.fractionCompleted))
            }
        }
        task.resume()
        
    }
    
    public func unzip(completion: @escaping ([Data])->()) {
        // unzip
        deleteFilesInWorkindDir()
        do {
            DispatchQueue.main.async {
                self.onStatus(localized(.unzipping))
            }
            let progress = Progress()
            observation = progress.observe(\.fractionCompleted) { (progress, _) in
                DispatchQueue.main.async {
                    self.onProgress(Float(progress.fractionCompleted))
                }
            }
            
            try FileManager.default.unzipItem(at: originArcivesPath.appendingPathComponent("\(model.downloadbleName).zip"), to: originimagesTempPath, skipCRC32: false, progress: progress, preferredEncoding: nil)
        } catch let err {
            debugPrint(" ERROR unzipItem: ", err)
            Notifications.shared.Show(RNSimpleView(text: localized(.unzipError), icon: Icons.cross.image(), iconColor: .systemRed))
        }
        debugPrint(" unzipItem OK")
        
        do {
            let lol = try FileManager.default.contentsOfDirectory(at: originimagesTempPath.appendingPathComponent("images"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            var resuptImages: [Data] = []
            lol.forEach { imageUrl in
                debugPrint("Image! URL: ", imageUrl.path)
                let imgData = FileManager.default.contents(atPath: imageUrl.path)
                resuptImages.append(imgData!)
            }
            DispatchQueue.main.async {
                completion(resuptImages)
            }
            // process files
        } catch let err {
            debugPrint("ERROR contentsOfDirectory: ", err)
            Notifications.shared.Show(RNSimpleView(text: localized(.tempClearError), icon: Icons.cross.image(), iconColor: .systemRed))
        }
    }
    
}
