//
//  Book+CoreDataProperties.swift
//  hackerbooks2.0
//
//  Created by Fran Navarro on 16/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var pdfURL: String?
    @NSManaged public var title: String?
    @NSManaged public var authors: NSSet?
    @NSManaged public var pdf: Pdf?
    @NSManaged public var photo: Photo?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for authors
extension Book {

    @objc(addAuthorsObject:)
    @NSManaged public func addToAuthors(_ value: Author)

    @objc(removeAuthorsObject:)
    @NSManaged public func removeFromAuthors(_ value: Author)

    @objc(addAuthors:)
    @NSManaged public func addToAuthors(_ values: NSSet)

    @objc(removeAuthors:)
    @NSManaged public func removeFromAuthors(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Book {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
