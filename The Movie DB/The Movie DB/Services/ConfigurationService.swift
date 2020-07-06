//
//  ConfigurationService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol ConfigurationServiceProtocol : class {
    func getConfigurations(params: [String: Any], success:@escaping (Configuration) -> (), failure: ((String?) -> Void)?)
}

extension ConfigurationService {
    func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

final class ConfigurationService : ResponseHandler, ConfigurationServiceProtocol {
    
    static let shared = ConfigurationService()
    var configuration: Configuration?
    var task : URLSessionTask?
    
    func getConfigurations(params: [String: Any] = [:], success:@escaping (Configuration) -> (), failure: ((String?) -> Void)? = nil) {
        
        // cancel previous request if already in progress
//        cancelPreviousTask()
        
        let urlString = encodedString(endPoint: Constants.configuration, params: params)
        let headers = ["Content-Type" : "application/json; charset=utf-8"]
        task = RequestService().sendRequest(urlString: urlString, method: .GET, HTTPHeaderFields: headers,  completion: ResponseHandler().result(success: success, failure: failure))
    }
}
