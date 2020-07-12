//
//  ConfigurationService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol ConfigurationServiceProtocol {
    mutating func getConfigurations(params: [String: Any], success:@escaping (Configuration) -> (), failure: ((String?) -> Void)?)
}

extension ConfigurationService {
    mutating func cancelPreviousTask() {
        task?.cancel()
        task = nil
    }
}

struct ConfigurationService : RequestServiceProtocol, URLEncodingProtocol, ResponseHandlerProtocol, ConfigurationServiceProtocol {
    
    static var shared = ConfigurationService()
    var configuration: Configuration? = Configuration.configuration()
    var task : URLSessionTask?
    
    mutating func getConfigurations(params: [String: Any] = [:], success:@escaping (Configuration) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.configuration, params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = ConfigurationService.sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: ConfigurationService.result(success: success, failure: failure))
    }
}
