//
//  ResponseParser.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/8/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: ResponseParserProtocol


// put all parser protocols here
// this way we will conform just ResponseParserProtocol to ResponseHandlerProtocol
// and good to go

struct QueryFail: Decodable {
    
    // In case of error/ invalid query
    let success: Bool?
    let statusCode: Int?
    let statusMessage : String
}

struct ResponseParser: ResponseParserProtocol {}


// MARK: ResponseParserProtocol

protocol ResponseParserProtocol: JSONDecoderProtocol {
    
    static func parse(data: Data?, response: URLResponse?, error: Error?, success: @escaping (Data) -> Void, failure: ((String?) -> Void)?)
    
    static func parse(data: Data?, response: URLResponse?, error: Error?, success: @escaping (UIImage) -> Void, failure: ((String?) -> Void)?)
}

extension ResponseParserProtocol {
    
    static func parse(data: Data?, response: URLResponse?, error: Error?, success: @escaping (Data) -> Void, failure: ((String?) -> Void)? = nil) {
        if let error = error, error.localizedDescription != "cancelled" {
            failure?(error.localizedDescription)
        }
        else if let data = data {
            success(data)
        }
        else {
            print("No error or data")
        }
    }
    
    static func parse(data: Data?, response: URLResponse?, error: Error?, success: @escaping (UIImage) -> Void, failure: ((String?) -> Void)? = nil) {
        if let error = error, error.localizedDescription != "cancelled" {
            failure?(error.localizedDescription)
        }
        else if let data = data, let image = UIImage(data: data) {
            guard let urlString = ImageDownloadService.urlString else {
                success(image)
                return
            }
            
            ImageDownloadService.imageCache.setObject(image, forKey: urlString as NSString)
            
            if let image = ImageDownloadService.imageCache.object(forKey: urlString as NSString) {
                success(image)
            }
            else {
                success(image)
            }
        }
        else {
            failure?("Image not available")
        }
    }

}


// MARK: JSONDecoderProtocol

protocol JSONDecoderProtocol {
    
    static func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: ((String?) -> Void)?)
    
    static func parse<T: NSManagedObject & Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: ((String?) -> Void)?)
}

extension JSONDecoderProtocol {
    
    static func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: ((String?) -> Void)? = nil) {
        if let error = error, error.localizedDescription != "cancelled" {
            failure?(error.localizedDescription)
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
                        failure?(failed.statusMessage)
                    }
                }
                
            }
            catch let DecodingError.dataCorrupted(context) {
                print("DecodingError.dataCorrupted '\(context)'")
                failure?(context.debugDescription)
            }
            catch let DecodingError.keyNotFound(key, context) {
                print("DecodingError.keyNotFound")
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                failure?(context.debugDescription)
                
            }
            catch let DecodingError.valueNotFound(value, context) {
                print("DecodingError.valueNotFound")
                
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                failure?(context.debugDescription)
            }
            catch let DecodingError.typeMismatch(type, context)  {
                print("DecodingError.typeMismatch")
                
                for key in context.codingPath {
                    print(key)
                }
                
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                failure?(context.debugDescription)
            }
            catch {
                failure?(error.localizedDescription)
            }
        }
    }
    
    static func parse<T: NSManagedObject & Decodable>(data: Data?, response: URLResponse?, error: Error?, success: @escaping (T) -> Void, failure: ((String?) -> Void)? = nil) {
        if let error = error {
            if let failure = failure, error.localizedDescription != "cancelled" {
                failure(error.localizedDescription)
            }
        }
        else if let data = data {
            do {
                if let httpURLResponse = response as? HTTPURLResponse {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    if httpURLResponse.statusCode == 200 {
                        let result = try decoder.decode(T.self, data: data, in: CoreDataManager.viewContext(), deferInsertion: false)
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


// MARK: CoreDataDecoderProtocol



extension CodingUserInfoKey {
    /// Required. Must be an NSManagedObjectContext.
    static let context = CodingUserInfoKey(rawValue: "context")!
    /// Optional. Boolean. If present and true, newly created objects are not inserted into the context.
    static let deferInsertion = CodingUserInfoKey(rawValue: "deferInsertion")!
}

extension JSONDecoder: CoreDataDecoderProtocol {}

protocol CoreDataDecoderProtocol: class {
    
    var userInfo: [CodingUserInfoKey : Any] { get  set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    func decode<T>(_ type: T.Type, data: Data, in context: NSManagedObjectContext, deferInsertion: Bool) throws -> T where T: NSManagedObject & Decodable
}

extension CoreDataDecoderProtocol {
    
    func decode<T>(_ type: T.Type, data: Data, in context: NSManagedObjectContext, deferInsertion: Bool) throws -> T where T: NSManagedObject & Decodable {
        
        userInfo[.context] = context
        userInfo[.deferInsertion] = deferInsertion
        defer {
            userInfo[.context] = nil
            userInfo[.deferInsertion] = nil
        }
        
        return try decode(type, from: data)
    }
}



