//
//  APIManager.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/27/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let API_Key = "e5ea3092880f4f3c25fbc537e9b37dc1"
    static let baseURL = "http://api.themoviedb.org/3/"
    
    static let popular = "movie/popular"
    static let movie = "movie" // Get the primary information about a movie.
    static let search = "search/movie" // Search for movies.
    
}

struct QueryFail: Decodable {
    
    // In case of error/ invalid query
    let success: Bool?
    let statusCode: Int?
    let statusMessage : String?
}


struct APIManager {
    static func request<T: Decodable> (httpMethod: String = "GET", endPoint: String, params: [String: Any] = [:], success: @escaping (T) -> Void, failure: @escaping (String?) -> Void) {
        
        // check network connectivity
        
        APIManager.sendRequest(httpMethod: httpMethod, endPoint: endPoint, params: params) { (data, response, error) in
            parseResponse(data: data, response: response, error: error, success: success, failure: failure)
        }
    }
    
    private static func sendRequest(httpMethod: String = "GET", endPoint: String, params: [String: Any] = [:], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var urlString: String = Constants.baseURL + endPoint
        
        var allParams: [String: Any] = ["api_key": Constants.API_Key] // default params
        if params.keys.count > 0 {
            Dictionary.merge(lhs: &allParams, rhs: params)
        }
        
        if httpMethod == "GET" {
            let urlEncodedString = allParams.urlEncodedString()
            urlString = urlString + (urlEncodedString.count > 0 ? "?" + urlEncodedString : urlEncodedString)
        }
        
        print("URL STRING: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("failed to create url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields?["Content-Type"] = "application/json; charset=utf-8"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // response received, now switch back to main queue
            DispatchQueue.main.async {
              completion(data, response, error)
            }
        }
        
        task.resume()
    }
    
    private static func parseResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: @escaping (String?) -> Void) {
        if let error = error {
            UIViewController.showAlert(message: error.localizedDescription)
            failure(error.localizedDescription)
        }
        else if let data = data {
            do {
                if let httpURLResponse = response as? HTTPURLResponse {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    if httpURLResponse.statusCode == 200 {
                        let result = try decoder.decode(T.self, from: data)
                        success(result)
                    }
                    else {
                        let failed = try decoder.decode(QueryFail.self, from: data)
                        UIViewController.showAlert(message: failed.statusMessage ?? "")
                        failure(failed.statusMessage)
                    }
                }
                
            }
            catch let DecodingError.dataCorrupted(context) {
                print("DecodingError.dataCorrupted '\(context)'")
//                UIViewController.showAlert(message: context.debugDescription)
//                failure(context.debugDescription)
            } catch let DecodingError.keyNotFound(key, context) {
                print("DecodingError.keyNotFound")
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                
            } catch let DecodingError.valueNotFound(value, context) {
                print("DecodingError.valueNotFound")
                
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                
            } catch let DecodingError.typeMismatch(type, context)  {
                print("DecodingError.typeMismatch")
                
                for key in context.codingPath {
                    print(key)
                }
                
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                
            } catch {
                UIViewController.showAlert(message: error.localizedDescription)
                failure(error.localizedDescription)
            }
        }
        else {
            print("No error or data")
        }
    }
}


