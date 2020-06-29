//
//  MovieList.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation



struct MovieList: Decodable {
    let page, totalResults, totalPages: Int
    let results: [Movie]
}
