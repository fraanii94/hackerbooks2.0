//
//  Annotation+CoreDataProperties.swift
//  hackerbooks2.0
//
//  Created by fran on 28/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData
 

extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation");
    }

    @NSManaged public var text: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var photo: Photo?
    @NSManaged public var localization: Localization?
    @NSManaged public var pdf: Pdf?

}
