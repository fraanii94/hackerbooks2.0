//
//  Localization+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by fran on 28/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


public class Localization: NSManagedObject {
    
    static let entityName = "Localization"
    
    convenience init(address: String,latitude: Double, longitude: Double,annotation: Annotation,inContext context:NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entity(forEntityName: Localization.entityName, in: context)!, insertInto: context)
        
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.annotation = annotation
    }

}
