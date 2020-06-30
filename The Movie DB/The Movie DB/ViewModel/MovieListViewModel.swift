//
//  MovieListViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol SearchMoviesProtocol {
    var query: String {get}
    func searchBarActivated()
    func searchFor(query: String)
    func searchEnded()
}

protocol ErrorHandlerProtocol {
    var onErrorHandler : ((String?) -> Void)? { get }
}

protocol MovieListProtocol: ErrorHandlerProtocol {
    var page: Int { get set }
    var totalPages: Int { get set }
    var allMovies: Dynamic<[Movie]>  { get set }
    
    func fetchPopularMovies(after: Int)
    func updateValues(movieList: MovieList)
}

class MovieListViewModel: MovieListProtocol {
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: Dynamic<[Movie]> = Dynamic([])
    
    var onErrorHandler: ((String?) -> Void)? = nil
    
    weak var service: MovieListServiceProtocol?
    init(service: MovieListServiceProtocol) {
        self.service = service
    }
    
    func fetchPopularMovies(after: Int) {
        if after == allMovies.value.count - 1 && page < totalPages {
            if page < totalPages {
                let next = page + 1
                let params: [String: Any] = ["page": next]
                service?.fetchPopularMovies(params: params, success: {[weak self] (movieList) in
                    self?.updateValues(movieList: movieList)
                }, failure: {[weak self] (message) in
                    if let onErrorHandler = self?.onErrorHandler {
                        onErrorHandler(message)
                    }
                })
            }
        }
    }
    
    func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        let all = allMovies.value + movieList.results
        allMovies.value = all
    }
}
