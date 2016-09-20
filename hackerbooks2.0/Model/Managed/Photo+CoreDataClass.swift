//
//  Photo+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData
import UIKit
@objc(Photo)
public class Photo: NSManagedObject {

    static let entityName = "Photo"

    var image : UIImage{
        get{
            return UIImage(data: photoData as! Data)!
        }
        set{
            photoData = UIImageJPEGRepresentation(newValue, 0.9) as NSData?
        }
    }
    
    convenience init(image: UIImage, context: NSManagedObjectContext){
        
        self.init(entity: NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!, insertInto: context)
        
        self.image = image
        
    }
    
    
}
