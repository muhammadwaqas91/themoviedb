//
//  MovieList.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation



struct MovieList: Decodable {
    let page, totalResults, totalPages: Int
    let results: [Movie]
    let favorites: [Favorite]?
}
