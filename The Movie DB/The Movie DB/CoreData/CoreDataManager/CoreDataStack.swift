//
//  CoreDataStack.swift
//  CollectionView
//
//  Created by Muhammad Waqas on 7/6/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String
    static let stack = CoreDataStack(modelName: "The_Movie_DB")
    
    // MARK: - Helping Properties
    lazy private var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls.last!)
        return urls.last!
    }()
    
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mom")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    // MARK: - Initializer
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var storeCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentDirectory.appendingPathComponent("\(modelName)).sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do  {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        }   catch   {
            print("sql persistant store coordinator error: \(error)")
        }
        return coordinator
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

