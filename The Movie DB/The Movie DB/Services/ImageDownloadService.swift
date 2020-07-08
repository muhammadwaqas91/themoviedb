//
//  ImageDownloadService.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/30/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloadServiceProtocol {
    mutating func downloadImage(urlString: String, success: @escaping((_ image: UIImage) -> Void), failure: ((String?) -> Void)?)
}

extension ImageDownloadService {
    mutating func cancelPreviousTask() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}

struct ImageDownloadService: RequestServiceProtocol, ResponseHandlerProtocol, ImageDownloadServiceProtocol {
    
    static var shared = ImageDownloadService()
    var task : URLSessionTask?
    static let imageCache = NSCache<NSString, UIImage>()
    
    mutating func downloadImage(urlString: String, success: @escaping((UIImage) -> Void), failure: ((String?) -> Void)? = nil) {
        
        if let image = ImageDownloadService.imageCache.object(forKey: urlString as NSString) {
            success(image)
        }
        else {
            print(urlString)
            let task = ImageDownloadService.sendRequest(urlString: urlString, method: nil, completion: ImageDownloadService.result(success: success, failure: failure))
            
            task?.resume()
        }
    }
}
