//
//  CoreDataManager.swift
//  CollectionView
//
//  Created by Muhammad Waqas on 7/6/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager   {
    
    private init() {
        
    }
        
    private static let stack = CoreDataStack.stack
    
    
    // MARK: Create
    static func insert(_ entityName: String) -> NSManagedObject? {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: stack.persistentContainer.viewContext)
        return object
    }
    
    
    // MARK: Fetch
    
    static func fetch(_ entityName: String, _ id: Int64) -> NSManagedObject? {
        let objects = fetchList(entityName, id)
        return objects?.first
    }
    
    static func fetch(_ entityName: String, _ predicate: NSPredicate? = nil, _ fetchLimit: Int? = nil, _ sortBy: [(key: String, ascending: Bool)]? = nil) -> NSManagedObject? {
        
        let objects = fetchList(entityName, predicate, fetchLimit, sortBy)
        return objects?.first
    }
    
    static func fetchList(_ entityName: String, _ id: Int64) -> [NSManagedObject]? {
        let predicate = NSPredicate(format: "id == %ld", id)
        let objects = fetchList(entityName, predicate)
        return objects
    }
    
    static func fetchList(_ entityName: String, _ predicate: NSPredicate? = nil, _ fetchLimit: Int? = nil, _ sortBy: [(key: String, ascending: Bool)]? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        fetchRequest.predicate = predicate
        
        if let sortBy = sortBy    {
            var sortDescriptors = [NSSortDescriptor]()
            for sortElement in sortBy   {
                let sortDescriptor = NSSortDescriptor(key: sortElement.key, ascending: sortElement.ascending)
                sortDescriptors.append(sortDescriptor)
            }
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        
        do {
            let objects = try stack.persistentContainer.viewContext.fetch(fetchRequest)
            return objects
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    // MARK: Delete
    static func delete(_ entityName: String, _ predicate: NSPredicate? = nil, _ fetchLimit: Int? = nil, _ sortBy: [(key: String, ascending: Bool)]? = nil) {
        let objects = fetchList(entityName, predicate, fetchLimit, sortBy)
        for object in objects ?? [] {
            stack.persistentContainer.viewContext.delete(object)
        }
    }
    
    static func saveContext() {
        stack.saveContext()
    }
    
    static func viewContext() -> NSManagedObjectContext {
        return stack.persistentContainer.viewContext
    }
}
