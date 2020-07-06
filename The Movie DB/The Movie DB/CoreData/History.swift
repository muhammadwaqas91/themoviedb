//
//  History.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/4/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

extension History {
    
    static func tags(_ predicate: NSPredicate? = nil) -> [History] {
        guard let tags = CoreDataManager.fetchList(Entity.History, predicate, 10, [("timeStamp", ascending: false)]) as? [History] else {
            return []
        }
        return tags
    }
    
    static func hasTags() -> Bool {
        return tags().count > 0
    }
    
    static func hasTag(_ tag: String) -> Bool {
        let predicate = NSPredicate(format: "tag == %@", tag)
        return tags(predicate).count > 0
    }
    
    static func addTag(_ tag: String) {
        let predicate = NSPredicate(format: "tag == %@", tag)
        _ = CoreDataManager.save(["tag":tag, "timeStamp": Date()], Entity.History, predicate)
    }
    
    static func removeTag(_ tag: String) {
        let predicate = NSPredicate(format: "tag == %@", tag)
        CoreDataManager.delete(Entity.History, predicate)
    }
}
