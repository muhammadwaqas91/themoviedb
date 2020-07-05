//
//  CoreDataStack.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/4/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    fileprivate let modelName: String
    fileprivate static let stack = CoreDataStack(modelName: "The_Movie_DB")
    
    lazy var context: NSManagedObjectContext = {
        var context: NSManagedObjectContext!
        if #available(iOS 10, *) {
            context = self.storeContainer.viewContext
        }
        else    {
            let coordinator = self.storeCoordinator
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            context.undoManager = nil
        }
        return context
    }()
    
    @available(iOS 10.0, *)
    lazy fileprivate var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy fileprivate var storeCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("\(self.modelName)).sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do  {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        }   catch   {
            print("sql persistant store coordinator error: \(error)")
        }
        return coordinator
    }()
    
    // MARK: - Helping Properties
    lazy fileprivate var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls.last!)
        return urls.last!
    }()
    
    lazy fileprivate var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "mom")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    // MARK: - Initializer
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Methods
    func saveContext()  {
        
        if context.hasChanges {
            print("items to be inserted: \(context.insertedObjects)")
            print("items to be updated: \(context.updatedObjects)")
            print("items to be deleted: \(context.deletedObjects)")
            
            do {
                try context.save()
            }   catch let nserror as NSError    {
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Class Methods
extension CoreDataStack {
    class func setup()  {
        _ = stack.context
        _ = stack.applicationDocumentDirectory
    }

    class func save()   {
        stack.saveContext()
    }
    
    static var context: NSManagedObjectContext {
        return stack.context
    }
    
    static func details(_ entityName: String) -> (entity: NSEntityDescription, managedObject: NSManagedObject) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        return (entity, managedObject)
    }
    
    
    static var storeCoordinator: NSPersistentStoreCoordinator    {
        var coordinator: NSPersistentStoreCoordinator!
        if #available(iOS 10, *) {
            coordinator = stack.storeContainer.persistentStoreCoordinator
        }
        else    {
            coordinator = stack.storeCoordinator
        }
        return coordinator
    }
}
