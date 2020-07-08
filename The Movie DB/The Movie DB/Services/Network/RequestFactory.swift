//
//  RequestFactory.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case GET
    case POST
}

final class RequestFactory {
    static func request(method: RequestMethod? = nil, url: URL, _ cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad) -> URLRequest {
        var request = URLRequest(url: url)
        if let method = method {
            request.httpMethod = method.rawValue
        }
        request.cachePolicy = cachePolicy
        return request
    }
}
