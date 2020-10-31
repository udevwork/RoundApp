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
    
    let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func download(completion: @escaping ([Data])->()) {
        guard let url = URL(string: self.model.link) else {
            return
        }
        
        deleteFilesInWorkindDir()
        
        downloadZip(url: url) { [self] (data, error) in
            do {
                try data?.write(to: savePath.appendingPathComponent("archive.zip"))
            } catch let err {
                debugPrint("FUCK ERROR WRITE: ", err)
                Notifications.shared.Show(RNSimpleView(text: localized(.archiveSaveError), icon: Icons.cross.image(), iconColor: .systemRed))
            }
            
            debugPrint("FUCK WRITE OK")
            
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
                
                try FileManager.default.unzipItem(at: savePath.appendingPathComponent("archive.zip"), to: savePath, skipCRC32: false, progress: progress, preferredEncoding: nil)
            } catch let err {
                debugPrint(" ERROR unzipItem: ", err)
                Notifications.shared.Show(RNSimpleView(text: localized(.unzipError), icon: Icons.cross.image(), iconColor: .systemRed))
            }
            debugPrint(" unzipItem OK")
            
            do {
                let lol = try FileManager.default.contentsOfDirectory(at: savePath.appendingPathComponent("images"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
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
    
    public func deleteFilesInWorkindDir(){
        // Deleting files
        do {
            let lol = try FileManager.default.contentsOfDirectory(at: savePath, includingPropertiesForKeys: nil, options: [])
            
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
    
}
