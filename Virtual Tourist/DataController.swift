//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 21/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    private let model: NSManagedObjectModel
    internal let coordinator: NSPersistentStoreCoordinator
    private let modelURL: URL
    internal let dbURL: URL
    internal let persistingContext: NSManagedObjectContext
    internal let backgroundContext: NSManagedObjectContext
    let context: NSManagedObjectContext
    
    
    
    // Shared Instance
    static func shared() -> DataController {
        struct Singleton {
            static var shared = DataController(modelName: "Virtual_Tourist")!
        }
        return Singleton.shared
    }
    
    init?(modelName: String) {
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil
        }
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        let fm = FileManager.default
        
        guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        
        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true
        ]
        
        do {
            try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: options as [NSObject : AnyObject]?)
        } catch {
            print("unable to add store at \(dbURL)")
        }
    }
    
    func addStoreCoordinator(_ storeType: String, configuration: String?, storeURL: URL, options : [NSObject:AnyObject]?) throws {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
    }
    
    
    func fetchPin(_ predicate: NSPredicate, entityName: String, sorting: NSSortDescriptor? = nil) throws -> Pin? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let pin = (try context.fetch(fr) as! [Pin]).first else {
            return nil
        }
        return pin
    }
    
    func fetchAllPins(_ predicate: NSPredicate? = nil, entityName: String, sorting: NSSortDescriptor? = nil) throws -> [Pin]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let pin = try context.fetch(fr) as? [Pin] else {
            return nil
        }
        return pin
    }
    
    func fetchPhotos(_ predicate: NSPredicate? = nil, entityName: String, sorting: NSSortDescriptor? = nil) throws -> [Photo]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let photos = try context.fetch(fr) as? [Photo] else {
            return nil
        }
        return photos
    }
    
    
    func dropAll() throws {
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
    }
    
    
    func saveContext() throws {
        context.performAndWait() {
            if context.hasChanges {
                try! context.save()
                persistingContext.perform() {
                    try! self.persistingContext.save()
                }
            }
        }
    }
    
    
    func autoSaving(interval:TimeInterval = 30) {
            guard interval > 0 else {
                print("cannot set negative autosave interval")
                return
            }
            if context.hasChanges {
                print("autoSaving")
                try! context.save()
                persistingContext.perform() {
                    try! self.persistingContext.save()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                self.autoSaving(interval: interval)
            }
        }
    
    
    
}
