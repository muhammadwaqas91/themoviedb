//
//  MovieListViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

protocol ErrorHandlerProtocol {
    var onErrorHandler : ((String?) -> Void)? { get }
}

protocol MovieListProtocol: ErrorHandlerProtocol {
    var page: Int { get set }
    var totalPages: Int { get set }
    var allMovies: Dynamic<[Movie]>  { get set }
    
    func fetchMovies()
    func updateValues(movieList: MovieList)
}


class MovieListViewModel: NSObject, MovieListProtocol {
        
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: Dynamic<[Movie]> = Dynamic([])
    
    var onErrorHandler: ((String?) -> Void)?
    
    func fetchMovies() {
        if page < totalPages {
            let next = page + 1
            let params: [String: Any] = ["page": next]
            APIManager.getPopularMovies(params: params, success: {[weak self] (movieList) in
                self?.updateValues(movieList: movieList)
                }, failure: { message in
                    if let handler = self.onErrorHandler {
                        handler(message)
                    }
            })
        }
    }
    
    func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        let all = allMovies.value + movieList.results
        allMovies.value = all
    }
}
