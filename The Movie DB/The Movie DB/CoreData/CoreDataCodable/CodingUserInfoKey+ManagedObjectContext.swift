//
//  CodingUserInfoKey+ManagedObjectContext.swift
//  CoreDataCodable
//
//  Created by Muhammad Waqas on 7/12/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import CoreData
import Foundation

public extension CodingUserInfoKey {
    static var managedObjectContext: CodingUserInfoKey! {
        return CodingUserInfoKey(rawValue: "managedObjectContext")!
    }
}

extension Decoder {
    
    func managedObjectContext() throws -> NSManagedObjectContext {
        guard let context = userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Missing managed object context key in userInfo for decoder")
            throw DecodingError.dataCorrupted(context)
        }
        return context
    }
    
}
