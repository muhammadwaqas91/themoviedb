//
//  Favorite.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/4/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

extension Favorite {

    static func isFavorite(_ id: Int64) -> Bool {
        return CoreDataManager.fetchList(Entity.Favorite, id)?.count ?? 0 > 0
    }
    
    static func add(_ id: Int64) {
        _ = CoreDataManager.save(["id":id], Entity.Favorite)
    }
    
    static func remove(_ id: Int64) {
        let predicate = NSPredicate(format: "id == %ld", id)
        CoreDataManager.delete(Entity.Favorite, predicate)
    }
}
