//
//  SearchService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {
    mutating func search(params: [String: Any], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)?)
}

extension SearchService {
    mutating func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

struct SearchService: RequestServiceProtocol, ResponseHandlerProtocol, SearchServiceProtocol {
    
    static let shared = SearchService()
    var task : URLSessionTask?
    
    mutating func search(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.search, params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = SearchService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: SearchService.result(success: success, failure: failure))
    }
}
