//
//  Pdf+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData

@objc(Pdf)
public class Pdf: NSManagedObject {
    
    static let entityName = "Pdf"
  
    
    
    convenience init(pdfData : Data, inContext context : NSManagedObjectContext) {
        
        self.init(entity: NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!, insertInto: context)
        self.pdfData = pdfData as NSData?
    }
}
