//
//  CoreDataManager.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/27/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager   {
    
    static var shared = CoreDataManager()
    
    class func insert(object: [String: Any], entityName: String) -> NSManagedObject?    {
        let details = CoreDataStack.details(entityName)
        let entity = details.entity
        let managedObject = details.managedObject
        
        return setValues(entity, object, managedObject)
    }
    
    class func update(list objects: [[String: Any]], entityName: String, predicate: NSPredicate){
               
        let details = CoreDataStack.details(entityName)
        let entity = details.entity

        guard  let objectsToUpdate = fetchList(entityName: entityName, predicate: predicate) else {
            return
        }
        
        for managedObject in objectsToUpdate {
            for object in objects {
                let _ = setValues(entity, object, managedObject)
            }
        }
    }
    
    class func update(object: [String: Any], entityName: String, id: Int64) -> NSManagedObject?  {
        let predicate = NSPredicate(format: "id == %ld", id)
        return self.update(object: object, entityName: entityName, predicate:predicate)
    }
    
    class func update(object: [String: Any], entityName: String, predicate: NSPredicate) -> NSManagedObject? {
        guard  let managedObject = fetchObject(entityName: entityName, predicate: predicate) else {
            return self.insert(object: object, entityName: entityName)
        }
        
        let details = CoreDataStack.details(entityName)
        let entity = details.entity
        
        return setValues(entity, object, managedObject)
    }
    
    class func delete(entityName: String, id: Int64) {
        let predicate = NSPredicate(format: "id == %ld", id)
        delete(entityName: entityName, predicate: predicate)
    }
    
    class func delete(entityName: String, predicate: NSPredicate?) {
        let coordinator = CoreDataStack.storeCoordinator
        let context = CoreDataStack.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let result = try coordinator.execute(request, with: context)
            print(result)
            
        } catch {
            print("Failed to execute request: \(error)")
        }
    }
    
    class func deleteAll(entityName: String, predicate: NSPredicate? = nil)  {
        let context = CoreDataStack.context
        let objects = fetchList(entityName: entityName, predicate: predicate, sortBy: nil)
        for object in objects!   {
            context.delete(object)
        }
    }
    
    
    // insert or update
    class func save(object: [String: Any], entityName: String, id: Int64? = nil) -> NSManagedObject   {
        var savedObject: NSManagedObject!
        if id == nil    {
            savedObject = CoreDataManager.insert(object: object, entityName: entityName)
        }
        else if CoreDataManager.exists(entityName: entityName, id: id!)    {
            savedObject = CoreDataManager.update(object: object, entityName: entityName, id: id!)
            
        }
        
        return savedObject
        
    }
    
    class func save(list:  [[String: Any]], entityName: String)  {
        let context = CoreDataStack.context
        let entity = CoreDataStack.details(entityName).entity
        
        var managedObjects = [NSManagedObject]()
        
        for object in list  {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObjects.append(setValues(entity, object, managedObject))
        }
    }
    
    fileprivate static func setValues(_ entity: NSEntityDescription, _ object: [String : Any], _ managedObject: NSManagedObject) -> NSManagedObject {
        let keys = Array(entity.attributesByName.keys)
        
        for (key, element) in object  {
            if keys.contains(key)   {
                managedObject.setValue(element, forKey: key)
            }
        }
        
        return managedObject
    }
    
    
    //MARK:- Existing Methods
    
    class func exists(entityName: String, id: Int64) -> Bool {
        let predicate = NSPredicate(format: "id == %ld", id)
        return countObjects(entityName: entityName, predicate: predicate) == 1
    }
    
    class func exists(entityName: String, predicate: NSPredicate) -> Bool {
        return countObjects(entityName: entityName, predicate: predicate) == 1
    }
    
    class func countObjects(entityName: String, predicate: NSPredicate?) -> Int  {
        let context = CoreDataStack.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        var count = 0
        do {
            count = try context.count(for: fetchRequest)
        } catch  {
            print("Could not fetch: \(error)")
        }
        return count
    }
    
    //MARK:- Fetching Methods
    
    class func fetchObject(entityName: String, id: Int64 ) -> NSManagedObject?  {
        let context = CoreDataStack.context
        let predicate = NSPredicate(format: "id == %ld", id)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        }   catch   {
            print("Could not fetch: \(error)")
        }
        return nil
    }
    
    class func fetchObject(entityName: String, predicate: NSPredicate? = nil) -> NSManagedObject?  {
        let context = CoreDataStack.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        }   catch   {
            print("Could not fetch: \(error)")
        }
        return nil
    }
    
    class func fetchList(entityName: String, predicate: NSPredicate? = nil, fetchLimit: Int? = nil, sortBy: [(key: String, ascending: Bool)]? = nil) -> [NSManagedObject]?  {
            let context = CoreDataStack.context
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = predicate
            if let fetchLimits = fetchLimit {
                fetchRequest.fetchLimit =  fetchLimits
            }
            
            if let sortedBy = sortBy    {
                var sortDescriptors = [NSSortDescriptor]()
                for sortElement in sortedBy   {
                    let sortDescriptor = NSSortDescriptor(key: sortElement.key, ascending: sortElement.ascending)
                    sortDescriptors.append(sortDescriptor)
                }
                fetchRequest.sortDescriptors = sortDescriptors
            }
            
            do {
                let results = try context.fetch(fetchRequest)
                return results
            }   catch   {
                print("Could not fetch: \(error)")
            }
            return nil
    }
}
