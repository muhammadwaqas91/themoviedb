//
//  MovieListViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol ErrorHandlerProtocol {
    var onErrorHandler : ((String?) -> Void)? { get }
}

protocol MovieListProtocol: ErrorHandlerProtocol {
    var page: Int { get set }
    var totalPages: Int { get set }
    var allMovies: Dynamic<[Movie]>  { get set }
    var newMovies: Dynamic<[Movie]>  { get set }
    func fetchMovies(after: Int)
}

class MovieListViewModel: MovieListProtocol {
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: Dynamic<[Movie]> = Dynamic([])
    var newMovies: Dynamic<[Movie]> = Dynamic([])
    
    var onErrorHandler: ((String?) -> Void)? = nil
    
    weak var popularService: MovieListServiceProtocol?
    
    init(_ popularService: MovieListServiceProtocol) {
        self.popularService = popularService
    }
    
    func fetchMovies(after: Int) {
        if (after == allMovies.value.count - 1) || allMovies.value.count == 0 && page < totalPages  {
            let next = page + 1
            let params: [String: Any] = ["page": next]
            if ConfigurationService.shared.configuration != nil {
                popularService?.fetchPopularMovies(params: params, success: {[weak self] (movieList) in
                    self?.updateValues(movieList: movieList)
                    }, failure: {[weak self] (message) in
                        if let onErrorHandler = self?.onErrorHandler {
                            onErrorHandler(message)
                        }
                })
            }
            else {
                ConfigurationService.shared.getConfigurations(success: {[weak self] (configuration) in
                    ConfigurationService.shared.configuration = configuration
                    self?.fetchMovies(after: after)
                })
            }
        }
    }
    
    
    private func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        let all = allMovies.value + movieList.results
        allMovies.value = all
        newMovies.value = movieList.results
    }
}
