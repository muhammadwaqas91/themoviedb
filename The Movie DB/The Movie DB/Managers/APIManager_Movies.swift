//
//  APIManager_PopularMovies.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/28/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

// MARK: - Get Popular

extension APIManager {
    
    // MARK: - Popular
    static func getPopularMovies(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        APIManager.request(endPoint: Constants.popular, params:params, success: { (movies: MovieList) in
            success(movies)
        }, failure: { message in
            if let failure = failure {
                failure(message)
            }
        })
    }
}


// MARK: - Get Details

extension APIManager {
    
    static func getMovieDetail(movie_id: Int, params: [String: Any] = [:], success:@escaping (Movie) -> (), failure: ((String?) -> Void)? = nil) {
        
        APIManager.request(endPoint: Constants.movie + "/\(movie_id)", params: params, success: { (details: Movie) in
            success(details)
        }, failure: { message in
            if let failure = failure {
                failure(message)
            }
        })
    }
}

extension APIManager {
    static var configuration: Configuration?
    
    static func getConfigurations(params: [String: Any] = [:], success:@escaping (Configuration) -> (), failure: ((String?) -> Void)? = nil) {
        
        APIManager.request(endPoint: Constants.configuration, params: params, success: { (configuration: Configuration) in
            success(configuration)
        }, failure: { message in
            if let failure = failure {
                failure(message)
            }
        })
    }
}


