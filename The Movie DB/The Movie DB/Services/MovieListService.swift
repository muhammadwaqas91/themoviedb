//
//  MovieListService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieListServiceProtocol {
    mutating func fetchMovies(_ serviceType: ServiceType, _ params: [String: Any], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)?)
}

extension MovieListService {
    mutating func cancelPreviousTask() {
        task?.cancel()
        task = nil
    }
}

struct MovieListService : RequestServiceProtocol, URLEncodingProtocol, ResponseHandlerProtocol, MovieListServiceProtocol {
        
    static var shared = MovieListService()
    var task : URLSessionTask?
    mutating func fetchMovies(_ serviceType: ServiceType, _ params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        
        cancelPreviousTask()
        
        var endPoint: String = ""
        switch serviceType {
        case .popular:
            endPoint = Constants.popular
        case .search:
            endPoint = Constants.search
            
        default:
            print("default called")
        }
        
        
        let urlString = encodedString(endPoint: endPoint, params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = MovieListService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: MovieListService.result(success: success, failure: failure))
    }
    
}
