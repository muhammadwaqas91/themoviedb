//
//  Configuration.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

extension Configuration: CodableManagedObjectProtocol {
    
    
    
    public enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(images, forKey: .images)
        try container.encode(changeKeys, forKey: .changeKeys)
    }
    
    
    public func setValues(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        images = try container.decodeIfPresent(Images.self, forKey: .images)
        changeKeys = try container.decodeIfPresent([String].self, forKey: .changeKeys)
    }
}

extension Configuration {
    
    public func encode(with coder: NSCoder) {
        coder.encode(images, forKey: CodingKeys.images.rawValue)
        coder.encode(changeKeys, forKey: CodingKeys.changeKeys.rawValue)
    }
}

extension Configuration {
    static func configuration() -> Configuration? {
        guard let configuration = CoreDataManager.fetch(Entity.Configuration) as? Configuration else {
            return nil
        }
        return configuration

    }
}

// MARK: - Images
public class Images: NSObject, Codable, NSCoding {
    
    public enum CodingKeys: String, CodingKey {
        case baseUrl
        case secureBaseUrl
        case backdropSizes
        case logoSizes
        case posterSizes
        case profileSizes
        case stillSizes
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(baseUrl, forKey: CodingKeys.baseUrl.rawValue)
        coder.encode(secureBaseUrl, forKey: CodingKeys.secureBaseUrl.rawValue)
        coder.encode(backdropSizes, forKey: CodingKeys.backdropSizes.rawValue)
        coder.encode(logoSizes, forKey: CodingKeys.logoSizes.rawValue)
        coder.encode(posterSizes, forKey: CodingKeys.posterSizes.rawValue)
        coder.encode(profileSizes, forKey: CodingKeys.profileSizes.rawValue)
        coder.encode(stillSizes, forKey: CodingKeys.stillSizes.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        baseUrl = coder.decodeObject(forKey: CodingKeys.baseUrl.rawValue) as? String
        secureBaseUrl = coder.decodeObject(forKey: CodingKeys.secureBaseUrl.rawValue) as? String
        backdropSizes = coder.decodeObject(forKey: CodingKeys.backdropSizes.rawValue) as? [String]
        logoSizes = coder.decodeObject(forKey: CodingKeys.logoSizes.rawValue) as? [String]
        posterSizes = coder.decodeObject(forKey: CodingKeys.posterSizes.rawValue) as? [String]
        profileSizes = coder.decodeObject(forKey: CodingKeys.profileSizes.rawValue) as? [String]
        stillSizes = coder.decodeObject(forKey: CodingKeys.stillSizes.rawValue) as? [String]
    }
    
    var baseUrl: String?
    var secureBaseUrl: String?
    var backdropSizes, logoSizes, posterSizes, profileSizes: [String]?
    var stillSizes: [String]?
}
