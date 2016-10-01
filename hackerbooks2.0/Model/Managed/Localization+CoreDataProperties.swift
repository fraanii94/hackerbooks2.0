//
//  Localization+CoreDataProperties.swift
//  hackerbooks2.0
//
//  Created by fran on 30/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData 

extension Localization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?
    @NSManaged public var annotation: Annotation?

}
