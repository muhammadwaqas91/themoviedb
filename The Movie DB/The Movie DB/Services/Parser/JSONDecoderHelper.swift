//
//  JSONDecoderHelper.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

struct QueryFail: Decodable {
    
    // In case of error/ invalid query
    let success: Bool?
    let statusCode: Int?
    let statusMessage : String?
}

final class JSONDecoderHelper {
    static func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: ((String?) -> Void)? = nil) {
        if let error = error {
            if let failure = failure {
                failure(error.localizedDescription)
            }
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
                        if let failure = failure {
                            failure(failed.statusMessage)
                        }
                    }
                }
                
            }
            catch let DecodingError.dataCorrupted(context) {
                print("DecodingError.dataCorrupted '\(context)'")
                if let failure = failure {
                    failure(context.debugDescription)
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("DecodingError.keyNotFound")
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                if let failure = failure {
                    failure(context.debugDescription)
                }
                
            } catch let DecodingError.valueNotFound(value, context) {
                print("DecodingError.valueNotFound")
                
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                if let failure = failure {
                    failure(context.debugDescription)
                }
                
            } catch let DecodingError.typeMismatch(type, context)  {
                print("DecodingError.typeMismatch")
                
                for key in context.codingPath {
                    print(key)
                }
                
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                if let failure = failure {
                    failure(context.debugDescription)
                }
                
            } catch {
                if let failure = failure {
                    failure(error.localizedDescription)
                }
            }
        }
        else {
            print("No error or data")
        }
    }
}

