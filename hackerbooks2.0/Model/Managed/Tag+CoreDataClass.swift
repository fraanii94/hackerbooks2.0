//
//  Tag+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    
    static let entityName = "Tag"
    
    convenience init(name: String, importance: Bool, inContext context:  NSManagedObjectContext){
        
        self.init(entity: NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!,insertInto: context)
        self.name = name
        self.importance = importance
        
        
        
    }

}
