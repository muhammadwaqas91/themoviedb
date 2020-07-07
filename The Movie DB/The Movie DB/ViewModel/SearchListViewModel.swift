//
//  SearchListViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

class SearchListViewModel: MovieListProtocol {
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: Dynamic<[Movie]> = Dynamic([])
    var newMovies: Dynamic<[Movie]> = Dynamic([])
    
    var onErrorHandler: ((String?) -> Void)? = nil
    var query: String = "" {
        didSet {
            fetchFreshMovies()
        }
    }
    
    weak var searchService: SearchServiceProtocol?
    
    init(_ searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }
    
    // paging while scrolling
    func fetchMovies(after: Int) {
        // isEmpty
        
        if allMovies.value.count == 0 || (after == allMovies.value.count - 1 && page < totalPages) {
            let next = page + 1
            let params: [String: Any] = ["page": next, "query": query]
            searchService?.search(params: params, success: {[weak self] (movieList) in
                self?.updateValues(movieList: movieList)
                
                // search is success
                // now if movieList.results.count > 0
                if let query = self?.query, movieList.results.count > 0 {
                    // if this keyword doesn't already exists
                    History.addTag(query)
                }
                
                
                if let onErrorHandler = self?.onErrorHandler, movieList.totalResults == 0 {
                    onErrorHandler("No records found, please try searching for something else.")
                }
                }, failure: {[weak self] (message) in
                    if let onErrorHandler = self?.onErrorHandler {
                        onErrorHandler(message)
                    }
            })
        }
    }
    
    // search from start with query change
    func fetchFreshMovies() {
        resetValue()
        fetchMovies(after: 0)
    }
    
    
    private func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        let all = allMovies.value + movieList.results
        allMovies.value = all
        newMovies.value = movieList.results
    }
    
    private func resetValue() {
        page = 0
        totalPages = 1
        allMovies.value = []
    }
}
