//
//  Book+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject {

    static let entityName = "Book"
    var pdfURL : URL {
        get{
            return URL(string: self.pdfPath!)!
        }
    }
    var imageURL : URL {
        get{
            return URL(string: self.imagePath!)!
        }
    }
    
    convenience init(title: String, pdfPath : String,imagePath : String,authors : NSSet, inContext context: NSManagedObjectContext){
        
        self.init(entity: NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!, insertInto: context)
        addToAuthors(authors)
        self.title = title
        self.pdfPath = pdfPath
        self.imagePath = imagePath
    }
}
//MARK: KVO
extension Book{
    
    // @nonobjc static let observableKeys = ["property1","property2"]
    func setupKVO(){
    
        // Alta en notificaciones
        // self.addObserver(self, forKeyPath: "Property", options: <#T##NSKeyValueObservingOptions#>, context: nil)
    }
    func tearDownKVO(){
        // Baja en notificaciones
        
    }
    
    //public override func observeValue(forKeyPath keyPath: String?,
     //                 of object: Any?,
      //                change: [NSKeyValueChangeKey : Any]?,
       //               context: UnsafeMutableRawPointer?) {
        // Accion a realizar
   // }
}

//MARK: Lifecycle
extension Book{
    // It is called just once
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setupKVO()
        
    }
    // It is called when the object is searched and when we access to its properties
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        setupKVO()
        
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        tearDownKVO()
    }
    
    
}





