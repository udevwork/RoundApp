//
//  ZipDowloader.swift
//  round
//
//  Created by Denis Kotelnikov on 27.09.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation

class FileDownloader {
    
    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }
    
    static func loadFileAsync(url: URL, completion: @escaping (Data?, Error?) -> Void, status: @escaping (String)->())
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler:
                                        {
                                            data, response, error in
                                            if error == nil
                                            {
                                                if let response = response as? HTTPURLResponse
                                                {
                                                    if response.statusCode == 200
                                                    {
                                                        if let data = data
                                                        {
                                                            
                                                            completion(data, error)
                                                            status("\(destinationUrl.path) \(error)")
                                                            
                                                            
                                                        }
                                                        else
                                                        {
                                                            completion(nil, error)
                                                            status("\(destinationUrl.path) \(error)")
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                completion(nil, error)
                                                status("\(destinationUrl.path) \(error)")
                                                
                                            }
                                        })
        task.resume()
        
    }
}
