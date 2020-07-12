//
//  JSONToNSManagedObjectWrapper.swift
//  CoreDataDemo
//
//  Created by Muhammad Waqas on 7/6/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import CoreData

protocol JSONToNSManagedObjectProtocol {
    /*
    // MARK: Create
    // create an entity, and set its values using json
    func insert(_ json: [String: Any], _ entityName: String) -> NSManagedObject?

    // MARK: Update
    // fetch an entity using id, and set its values using json
    func update(_ json: [String: Any], _ entityName: String, _ id: Int64) -> NSManagedObject?

    // fetch an entity using predicate, if its not available then create, and set its values using json
    func update(_ json: [String: Any], _ entityName: String, _ predicate: NSPredicate?) -> NSManagedObject?

    // fetch list of entity using predicate, if its not available then return, and set its values using json
    func updateList(_ json: [[String: Any]], _ entityName: String, _ predicate: NSPredicate?) -> [NSManagedObject]


    // update values of entity matching keys using json
    func setValues(_ json: [String : Any], _ managedObject: NSManagedObject) -> NSManagedObject
    
    */
    
    
    // MARK: Save (Create or Update)
    
    static func save(_ json: [String: Any], _ entityName: String, _ id: Int64) -> NSManagedObject?
    static func save(_ json: [String: Any], _ entityName: String, _ predicate: NSPredicate?) -> NSManagedObject?
    static func saveList(_ json: [[String: Any]], _ entityName: String, _ predicate: NSPredicate?) -> [NSManagedObject]
}


extension CoreDataManager: JSONToNSManagedObjectProtocol {
    
    // these methods are marked private to avoid confusion
    // use save methods it will create or update NSManagedObject accordingly
    
    private static func insert(_ json: [String : Any], _ entityName: String) -> NSManagedObject? {
        guard let managedObject = CoreDataManager.insert(entityName) else {
            return nil
        }
        return setValues(json, managedObject)
    }
    
    private static func update(_ json: [String : Any], _ entityName: String, _ id: Int64) -> NSManagedObject? {
        let predicate = NSPredicate(format: "id == %ld", id)
        return update(json, entityName, predicate)
    }
    
    private static func update(_ json: [String : Any], _ entityName: String, _ predicate: NSPredicate? = nil) -> NSManagedObject? {
        guard let managedObject = CoreDataManager.fetch(entityName, predicate) else {
            return insert(json, entityName)
        }
        return setValues(json, managedObject)
    }
    
    private static func updateList(_ json: [[String : Any]], _ entityName: String, _ predicate: NSPredicate? = nil) -> [NSManagedObject] {
        guard let managedObjects = CoreDataManager.fetchList(entityName, predicate) else {
            var managedObjects: [NSManagedObject] = []
            
            for json in json {
                guard let managedObject = insert(json, entityName) else {
                    continue
                }
                managedObjects.append(managedObject)
            }
            return managedObjects
        }
        
        for managedObject in managedObjects {
            for json in json {
                _ = setValues(json, managedObject)
            }
        }
        
        return managedObjects
    }
    
    private static func setValues(_ json: [String : Any], _ managedObject: NSManagedObject) -> NSManagedObject {
        let keys = Array(managedObject.entity.attributesByName.keys)
        for (key, value) in json {
            if keys.contains(key) {
                managedObject.setValue(value, forKey: key)
            }
        }
        return managedObject
    }
    
    
    
    // MARK: Save (Create or Update)
        
    static func save(_ json: [String : Any], _ entityName: String, _ id: Int64) -> NSManagedObject? {
        return update(json, entityName, id)
    }
    
    static func save(_ json: [String : Any], _ entityName: String, _ predicate: NSPredicate? = nil) -> NSManagedObject? {
        return update(json, entityName, predicate)
    }
    
    static func saveList(_ json: [[String : Any]], _ entityName: String, _ predicate: NSPredicate? = nil) -> [NSManagedObject] {
        return updateList(json, entityName, predicate)
    }
}
