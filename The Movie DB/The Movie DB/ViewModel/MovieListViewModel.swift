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
    var allMovies: [Movie] { get set }
    var newMovies: Dynamic<[Movie]> { get set }
    var serviceType: ServiceType { get set }
    func fetchMovies(after: Int)
    func updateValues(movieList: MovieList)
    
    // if you need fresh results
    func fetchFreshMovies()
    func resetValue()
}

protocol SearchListProtocol {
    var query: String { get set }
    func fetchFreshMovies()
    func resetValue()
}

enum ServiceType {
    case favorite
    case popular
    case search
}

class MovieListViewModel: MovieListProtocol, SearchListProtocol {
    
    var query: String = ""
    
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: [Movie] = []
    var newMovies: Dynamic<[Movie]> = Dynamic([])
    var onErrorHandler: ((String?) -> Void)? = nil
    var serviceType: ServiceType {
        didSet {
            switch serviceType {
            case .popular, .search:
                fetchFreshMovies()
            case .favorite:
                fetchFavoriteMovies()
            }
        }
    }
    
    init(_ serviceType: ServiceType) {
        self.serviceType = serviceType
    }
    
    func fetchMovies(after: Int) {
        
        let isLast = after == allMovies.count - 1
        let hasMore = page < totalPages
        
        if isLast && hasMore || allMovies.isEmpty && hasMore  {
            let next = page + 1
            var params: [String: Any] = ["page": next]
            switch serviceType {
            case .popular:
                fetchPopularMovies(params)
            case .search:
                params["query"] = query
                fetchSearchMovies(params)
            case .favorite:
                fetchFavoriteMovies()
            }
            
        }
    }
    
    private func fetchPopularMovies(_ params: [String: Any]) {
        if ConfigurationService.shared.configuration != nil {
            sendRequest(params)
        }
        else {
            ConfigurationService.shared.getConfigurations(success: {[weak self] (configuration) in
                CoreDataManager.saveContext()
                ConfigurationService.shared.configuration = configuration
                self?.sendRequest(params)
            })
        }
    }
    
    private func fetchSearchMovies(_ params: [String: Any]) {
        sendRequest(params) {[weak self] (movieList) in
            // search is success
            // now if movieList.results.count > 0
            if let query = self?.query, movieList.results.count > 0 {
                // if this keyword doesn't already exists
                History.addTag(query)
            }
            
            
            if let onErrorHandler = self?.onErrorHandler, movieList.totalResults == 0 {
                onErrorHandler("No records found, please try searching for something else.")
            }
        }
    }
    
    private func fetchFavoriteMovies() {
        totalPages = 0
        allMovies = Favorite.favorites()
        newMovies.value = allMovies
    }
    
    
    private func sendRequest(_ params: [String: Any], success: ((MovieList) -> ())? = nil) {
        MovieListService.shared.fetchMovies(serviceType, params, success: {[weak self] (movieList) in
            self?.updateValues(movieList: movieList)
            success?(movieList)
            }, failure: {[weak self] (message) in
                self?.onErrorHandler?(message)
        })
    }
    
    func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        allMovies = allMovies + movieList.results
        newMovies.value = movieList.results
    }
    
    // results from start
    func fetchFreshMovies() {
        resetValue()
        fetchMovies(after: 0)
    }
    
    func resetValue() {
        page = 0
        totalPages = 1
        allMovies = []
        newMovies.value = []
    }
}
