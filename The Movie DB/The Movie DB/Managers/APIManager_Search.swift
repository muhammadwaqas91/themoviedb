//
//  APIManager_SearchMovies.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/28/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

// MARK: - Search

extension APIManager {
    
    // query
    // page
    
    static func searchForMovies(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        APIManager.request(endPoint: Constants.search, params: params, success: { (popularMovies: MovieList) in
            success(popularMovies)
        }, failure: { message in
            if let failure = failure {
                failure(message)
            }
        })
    }
}
