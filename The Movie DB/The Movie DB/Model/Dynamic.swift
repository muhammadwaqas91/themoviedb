//
//  Dynamic.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

final class Dynamic<T> {
  //1
  typealias Listener = (T) -> Void
  var listener: Listener?
  //2
  var value: T {
    didSet {
      listener?(value)
    }
  }
  //3
  init(_ value: T) {
    self.value = value
  }
  //4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}




//class Dynamic<T> {
//    
//    typealias CompletionHandler = ((T) -> Void)
//    
//    var value : T {
//        didSet {
//            self.notify()
//        }
//    }
//    
//    private var observers = [String: CompletionHandler]()
//    
//    init(_ value: T) {
//        self.value = value
//    }
//    
//    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
//        observers[observer.description] = completionHandler
//    }
//    
//    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
//        self.addObserver(observer, completionHandler: completionHandler)
//        self.notify()
//    }
//    
//    private func notify() {
//        print(observers)
//        observers.forEach({ $0.value(value) })
//    }
//    
//    deinit {
//        observers.removeAll()
//    }
//}
