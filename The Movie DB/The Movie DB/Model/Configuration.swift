//
//  Configuration.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

struct Configuration: Decodable {
    var images: Images
    var changeKeys: [String]
}

// MARK: - Images
struct Images: Decodable {
    var baseUrl: String
    var secureBaseUrl: String
    var backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    var stillSizes: [String]
}
