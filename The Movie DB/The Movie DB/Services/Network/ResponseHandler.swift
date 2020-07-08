//
//  ResponseHandler.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit

protocol URLEncodingProtocol {
    func encodedString(baseURL: String, endPoint: String, params: [String: Any]) -> String
}

extension URLEncodingProtocol {
    func encodedString(baseURL: String = Constants.baseURL, endPoint: String, params: [String: Any]) -> String {
        var allParams: [String: Any] = ["api_key": Constants.API_Key] // default params
        if params.keys.count > 0 {
            Dictionary.merge(lhs: &allParams, rhs: params)
        }
        
        var urlString: String = baseURL + endPoint
        let urlEncodedString = allParams.urlEncodedString()
        urlString = urlString + (urlEncodedString.count > 0 ? "?" + urlEncodedString : urlEncodedString)
        return urlString
    }
}

protocol ResponseHandlerProtocol: ResponseParserProtocol {
    static func result<T: Decodable>(success: @escaping (T) -> Void, failure: ((String?) -> Void)?) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    
    static func result(success: @escaping (Data) -> Void, failure: ((String?) -> Void)?) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    
    static func result(success: @escaping (UIImage) -> Void, failure: ((String?) -> Void)?) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
}

extension ResponseHandlerProtocol {
    static func result<T: Decodable>(success: @escaping (T) -> Void, failure: ((String?) -> Void)? = nil) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        return { data, response, error in
            DispatchQueue.global(qos: .background).async(execute: {
                ResponseParser.parse(data: data, response: response, error: error, success: success, failure: failure)
            })
            
        }
    }
    
    static func result(success: @escaping (Data) -> Void, failure: ((String?) -> Void)?) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        return { data, response, error in
            DispatchQueue.global(qos: .background).async(execute: {
                ResponseParser.parse(data: data, response: response, error: error, success: success, failure: failure)
            })
            
        }
    }
    
    static func result(success: @escaping (UIImage) -> Void, failure: ((String?) -> Void)?) -> ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        return { data, response, error in
            DispatchQueue.global(qos: .background).async(execute: {
                ResponseParser.parse(data: data, response: response, error: error, success: success, failure: failure)
            })
            
        }
    }
}
