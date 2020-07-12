//
//  CodableManagedObjectProtocol.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/12/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import CoreData
import Foundation

public protocol CodableManagedObjectProtocol: class, Codable {
    init(from decoder: Decoder) throws
    func setValues(from decoder: Decoder) throws
}

public extension CodableManagedObjectProtocol where Self: NSManagedObject {
    init(from decoder: Decoder) throws {
        self.init(context: try decoder.managedObjectContext())
        try setValues(from: decoder)
    }
    
}
