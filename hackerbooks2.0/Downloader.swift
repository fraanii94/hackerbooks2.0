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
    
    func asyncData(_ url: URL, final: @escaping completion) {
        DispatchQueue.global(qos: .default).async {
        var data : Data
        
        data = try! Data(contentsOf: url)
        
        DispatchQueue.main.async {
            final(data)
        }
                
    }
        
        
    }

    
    
    
    
}




























