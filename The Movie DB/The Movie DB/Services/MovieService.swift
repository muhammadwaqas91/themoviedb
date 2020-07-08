//
//  MovieService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieServiceProtocol {
    mutating func getMovieDetail(movie_id: Int, params: [String: Any], success:@escaping (Movie) -> (), failure: ((String?) -> Void)?)
}

extension MovieService {
    mutating func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

struct MovieService: RequestServiceProtocol, ResponseHandlerProtocol, MovieServiceProtocol {
    
    static let shared = MovieService()
    var task : URLSessionTask?
    
    mutating func getMovieDetail(movie_id: Int, params: [String: Any] = [:], success:@escaping (Movie) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.movie + "/\(movie_id)", params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = MovieService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: MovieService.result(success: success, failure: failure))
    }
}
