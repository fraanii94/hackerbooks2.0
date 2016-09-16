//
//  JSONManager.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
class JSONManager : DownloaderDelegate{
   
    let url = URL(string: "https://keepcodigtest.blob.core.windows.net/containerblobstest/books_readable.json")!
    typealias JSONObject        = AnyObject
    typealias JSONDictionary    = [String : JSONObject]
    typealias JSONArray         = [JSONDictionary]
    
    private func decode(book json: JSONDictionary) throws {
        
        guard let pdfURL = json["pdf_url"] as? String, let pdf = NSURL(string: pdfURL) else {
            throw BookError.wrongURLFormatForJSONResource
        }
        
        guard let imgURL = json["image_url"] as? String, let img = NSURL(string: imgURL) else {
            throw BookError.wrongURLFormatForJSONResource
        }
        guard let title = json["title"] as? String else {
            throw BookError.JSONParsingError
        }
        guard let tags = json["tags"]?.components(separatedBy: ", ") else {
            throw BookError.JSONParsingError
        }
        guard let authors = json["authors"]?.components(separatedBy:", ") else {
            throw BookError.JSONParsingError
        }
        
        
        print("t" + "\(title)")
        
        
    }
    
    
    private func decode(book json: JSONDictionary?) throws -> Book {
        // Comprobar caso opcional
        if case .some(let book) = json {
            return try decode(book: book)
        }else {
            throw BookError.nilBook
        }
    }
    
    public func downloadBooks(){
    
        let downloader = Downloader()
        downloader.asyncData(self.url)
        
    }
    
    func downloader(_ sender: Downloader, didEndDownloadingFrom url: URL, data: Data) {
        
        if url == self.url {
            self.validateData(data)
        }
        
    }
    
    

}








