//
//  Constants.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/27/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

struct Constants {
    static let API_Key = "e5ea3092880f4f3c25fbc537e9b37dc1"
    static let baseURL = "http://api.themoviedb.org/3"
    
    static let popular = "/movie/popular"
    static let search = "/search/movie"
    static let movie = "/movie"
    
    static let configuration = "/configuration"
}

// MARK:- CoreData Configuration

// entity names
struct Entity {
    static let Favorite = "Favorite"
    static let History = "History"
}

// entities attributes
struct Attributes  {
    static let id = "id"
    static let tag = "tag"
}

