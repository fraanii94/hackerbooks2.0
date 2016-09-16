//
//  Book+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject {

    static let entityName = "Book"
    
    init(title: String, pdfURL : String,imageURL : String, inContext context: NSManagedObjectContext){
        
        super.init(entity: NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!, insertInto: context)
        
        self.title = title
        self.pdfURL = pdfURL
        self.imageURL = imageURL
    }
}
