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


// entity names
struct Entity {
    static let Configuration = "Configuration"
    static let Favorite = "Favorite"
    static let History = "History"
}

enum Notifications: String {
    case addFavorite = "addFavorite"
    case removeFavorite = "removeFavorite"
    
    var value: NSNotification.Name {
        get {
            NSNotification.Name(self.rawValue)
        }
    }
}

