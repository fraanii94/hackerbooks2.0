//
//  Downloader.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation


public class Downloader {
    
    typealias completion = (Data) -> ()
    weak public var delegate: DownloaderDelegate?
    public func asyncData(_ url: URL) ->(){
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            var data : Data
            do{
                if self.delegate?.downloader(self, shouldStartDownloadingFrom: url) == true{
                    self.delegate?.downloader(self, willStartDownloadingFrom: url)
                    data = try Data(contentsOf: url)
                    self.delegate?.downloader(self, didEndDownloadingFrom: url,data: data)
                    DispatchQueue.main.async {
                        self.sendNotification(url: url, data: data)
                    }
                    
                }
                
                
            }catch let error as NSError{
                self.delegate?.downloader(self, didFailDownloadingFrom: url, error: error)
            }
        }
        
    }
    
    let didDownloadData = Notification.Name(rawValue: "didDownloadData")
    
    private func sendNotification(url: URL, data: Data){
        let nc = NotificationCenter.default
        let notification = Notification(name: didDownloadData, object: self, userInfo: [url : url,data : data])
        
        nc.post(notification)
    }
    
    
    
    
}

// MARK: Delegate

public protocol DownloaderDelegate : class {
    
    func downloader(_ sender: Downloader, shouldStartDownloadingFrom url: URL )->Bool
    
    func downloader(_ sender: Downloader, willStartDownloadingFrom url: URL)
    
    func downloader(_ sender: Downloader, didEndDownloadingFrom url: URL,data:Data)
    
    func downloader(_ sender: Downloader, didFailDownloadingFrom url: URL, error: NSError)
    

    
    
}

extension DownloaderDelegate {
    
    func downloader(_ sender: Downloader,shouldStartDownloadingFrom url: URL) -> Bool{
        return true
    }
    func downloader(_ sender: Downloader, willStartDownloadingFrom url: URL){}
    
    
    func downloader(_ sender: Downloader, didFailDownloadingFrom url:URL, error: NSError){
        print("An error occured: \(error)" )
    }
    
}


























