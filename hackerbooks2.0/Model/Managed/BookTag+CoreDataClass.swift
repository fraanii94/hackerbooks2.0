//
//  BookTag+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by fran on 19/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {

    static let entityName = "BookTag"
    
    
    convenience init(book : Book, tag: Tag,inContext context: NSManagedObjectContext){
        self.init(entity: NSEntityDescription.entity(forEntityName: BookTag.entityName,in:context)!,insertInto: context)
        
        self.book = book
        self.tag = tag
        
    }
}
