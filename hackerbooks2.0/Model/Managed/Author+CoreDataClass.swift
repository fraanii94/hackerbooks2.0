//
//  Author+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData

@objc(Author)
public class Author: NSManagedObject {
    
    static let entityName = "Author"
    
    
    convenience init(name : String,inContext context: NSManagedObjectContext){
        self.init(entity: NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!,insertInto: context)
        self.name = name
        
    }
    
}
