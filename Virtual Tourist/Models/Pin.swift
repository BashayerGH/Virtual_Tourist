//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 22/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {
    

    static let name = "Pin"
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var photos: NSSet?
    
    convenience init(latitude: String, longitude: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Pin.name, in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Error in Entity name!")
        }
    }
    
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

    
}
