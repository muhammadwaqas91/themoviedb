//
//  MovieListService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

protocol MovieListServiceProtocol : class {
    func fetchPopularMovies(params: [String: Any], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)?)
}

extension MovieListService {
    func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

final class MovieListService : ResponseHandler, MovieListServiceProtocol {
    
    static let shared = MovieListService()
    var task : URLSessionTask?
    
    
    
    func fetchPopularMovies(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.popular, params: params)
       let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = RequestService().sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: ResponseHandler().result(success: success, failure: failure))
    }
    
}
