//
//  Pdf+CoreDataProperties.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var pdfData: NSData?
    @NSManaged public var book: Book?

}
