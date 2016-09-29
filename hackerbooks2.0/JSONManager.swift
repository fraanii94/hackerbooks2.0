//
//  JSONManager.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData
class JSONManager {
   
    var url : URL
    var model : CoreDataStack
    
    typealias JSONObject        = AnyObject
    typealias JSONDictionary    = [String : JSONObject]
    typealias JSONArray         = [JSONDictionary]
    
    init(url: URL, model : CoreDataStack){
        self.url = url
        self.model = model
        
    }
    
    public func downloadBooks(){
        let downloader = Downloader()
        downloader.asyncData(self.url) { (data : Data) in
            self.didDownload(data : data)
            
        }
        
        
    }
    
    func validateData(_ data: Data){
        do{
            let json :JSONArray = try (JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? JSONArray)!
            
            for book in json{
                try self.decodeAndCreate(book: book)
            }
            
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func didDownload(data : Data) {
        
        if url == self.url {
            self.validateData(data)
        }
        
    }
    

}

extension JSONManager {
    
    func decodeAndCreate(book json: JSONDictionary) throws {
        
        guard let pdfURL = json["pdf_url"] as? String, let _ = NSURL(string: pdfURL) else {
            throw BookError.wrongURLFormatForJSONResource
        }
        
        guard let imgURL = json["image_url"] as? String, let _ = NSURL(string: imgURL) else {
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

      
        var authorSet = NSSet()
        for author in authors{
            let authorRequest : NSFetchRequest<Author> = Author.fetchRequest()
            authorRequest.predicate = NSPredicate(format: "name == %@", author)
            authorRequest.fetchLimit = 1
            let result = try! self.model.context.fetch(authorRequest)
            
            if result.count == 0{
                let a = Author(name: author, inContext: self.model.context)
                authorSet = authorSet.adding(a) as NSSet
            }else{
                authorSet = authorSet.adding(result[0]) as NSSet
            }

        }
        
        
        let bookRequest : NSFetchRequest<Book> = Book.fetchRequest()
        bookRequest.predicate = NSPredicate(format: "title == %@", title)
        bookRequest.fetchLimit = 1
        
        let bookCount = try! self.model.context.count(for: bookRequest)
        
        if bookCount == 0 {
            let b = Book(title: title, pdfPath: pdfURL, imagePath: imgURL,authors:authorSet, inContext: self.model.context)
            
            for tag in tags{
                let tagRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
                tagRequest.predicate = NSPredicate(format: "name == %@", tag)
                tagRequest.fetchLimit = 1
                let result = try! self.model.context.fetch(tagRequest)
                
                if result.count == 0{
                     let t = Tag(name: tag, importance: false, inContext: self.model.context)
                     let _ = BookTag(book: b, tag: t, inContext: self.model.context)
                }else{
                    let _ = BookTag(book: b, tag: result[0], inContext: self.model.context)

                }
            }

        }
        
    }
    
    
    func decodeAndCreate(book json: JSONDictionary?) throws -> Book {
        // Comprobar caso opcional
        if case .some(let book) = json {
            return try decodeAndCreate(book: book)
        }else {
            throw BookError.nilBook
        }
    }
    
  
    
}







