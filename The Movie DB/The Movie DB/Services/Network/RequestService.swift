//
//  RequestService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation


protocol RequestServiceProtocol {
    static func sendRequest(urlString: String, method: RequestMethod?, _ cachePolicy: URLRequest.CachePolicy, HTTPHeaderFields: [String : String], completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask?
}

extension RequestServiceProtocol {
    static func sendRequest(urlString: String, method: RequestMethod? = .GET, _ cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad, HTTPHeaderFields: [String : String] = [:], completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = RequestFactory.request(method: method, url: url, cachePolicy)
        
        for (key, value) in HTTPHeaderFields {
            request.allHTTPHeaderFields?[key] = value
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
        return task
    }
}
