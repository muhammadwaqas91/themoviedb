//
//  MovieDetailService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/8/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

protocol MovieDetailServiceProtocol {
    mutating func getMovieDetail(movie_id: Int, params: [String: Any], success:@escaping (MovieDetail) -> (), failure: ((String?) -> Void)?)
}

extension MovieDetailService {
    mutating func cancelPreviousTask() {
        task?.cancel()
        task = nil
    }
}

struct MovieDetailService: RequestServiceProtocol, URLEncodingProtocol, ResponseHandlerProtocol, MovieDetailServiceProtocol {
    
    static let shared = MovieDetailService()
    var task : URLSessionTask?
    
    mutating func getMovieDetail(movie_id: Int, params: [String: Any] = [:], success:@escaping (MovieDetail) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.movie + "/\(movie_id)", params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = MovieDetailService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: MovieDetailService.result(success: success, failure: failure))
    }
}
