//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 22/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    static let name = "Photo"
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var pin: Pin?

    
    convenience init(title: String, imageUrl: String, Pin1: Pin, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: Photo.name, in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.image = nil
            self.imageUrl = imageUrl
            self.pin = Pin1
            
        } else {
            fatalError("Error!")
        }
    }
    
}
