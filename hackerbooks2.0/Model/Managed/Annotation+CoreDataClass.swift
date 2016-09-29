//
//  Annotation+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by fran on 28/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


public class Annotation: NSManagedObject {
    
    static let entityName = "Annotation"
    
    convenience init(pdf:Pdf,photo : Photo,localization:Localization, inContext context: NSManagedObjectContext){
        self.init(entity: NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!, insertInto: context)
        
        self.pdf = pdf
        self.photo = photo
        self.localization = localization
        
        self.creationDate = Date() as NSDate?
        self.modificationDate = Date() as NSDate?
    }

}
