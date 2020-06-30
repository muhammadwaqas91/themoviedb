//
//  RequestService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation





final class RequestService {
    
    func sendRequest(urlString: String, method: RequestMethod = .GET, session: URLSession = URLSession(configuration: .default), HTTPHeaderFields: [String : String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = RequestFactory.request(method: method, url: url)
        
        // if internet is not available
        if let reachability = Reachability(), !reachability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // response received, now switch back to main queue
            DispatchQueue.main.async {
              completion(data, response, error)
            }
        }
        task.resume()
        return task
    }
}
