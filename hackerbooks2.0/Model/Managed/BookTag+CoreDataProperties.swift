//
//  BookTag+CoreDataProperties.swift
//  hackerbooks2.0
//
//  Created by fran on 19/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


extension BookTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTag> {
        return NSFetchRequest<BookTag>(entityName: "BookTag");
    }

    @NSManaged public var book: Book?
    @NSManaged public var tag: Tag?

}
