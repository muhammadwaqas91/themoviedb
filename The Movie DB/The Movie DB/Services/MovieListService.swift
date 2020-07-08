//
//  MovieListService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieListServiceProtocol {
    mutating func fetchPopularMovies(params: [String: Any], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)?)
}

extension MovieListService {
    mutating func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

struct MovieListService : RequestServiceProtocol, ResponseHandlerProtocol, MovieListServiceProtocol {
    
    static let shared = MovieListService()
    var task : URLSessionTask?
    
    
    
    mutating func fetchPopularMovies(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.popular, params: params)
       let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = MovieListService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: MovieListService.result(success: success, failure: failure))
    }
    
}
