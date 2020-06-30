//
//  MovieListViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
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

protocol MovieListServices {
    func fetchPopularMovies(_ viewModel: MovieListViewModel)
    func fetchSearchResults(_ viewModel: MovieListViewModel, _ query: String)
}



extension MovieListServices {
    
    func fetchPopularMovies(_ viewModel: MovieListViewModel) {
        if viewModel.page < viewModel.totalPages {
            let next = viewModel.page + 1
            let params: [String: Any] = ["page": next]
            APIManager.getPopularMovies(params: params, success: {[weak viewModel] (movieList) in
                viewModel?.updateValues(movieList: movieList)
                }, failure: { message in
                    if let handler = viewModel.onErrorHandler {
                        handler(message)
                    }
            })
        }
    }

    func fetchSearchResults(_ viewModel: MovieListViewModel, _ query: String) {

    }
}

protocol MovieListProtocol: ErrorHandlerProtocol {
    var page: Int { get set }
    var totalPages: Int { get set }
    var allMovies: Dynamic<[Movie]>  { get set }
    
    func fetchPopularMovies(after: Int)
    func updateValues(movieList: MovieList)
}


class MovieListViewModel: NSObject, MovieListProtocol, MovieListServices {
    
    
    var page: Int = 0
    var totalPages: Int = 1
    var allMovies: Dynamic<[Movie]> = Dynamic([])
    
    var onErrorHandler: ((String?) -> Void)?
    
    
    func fetchPopularMovies(after: Int) {
        if after == allMovies.value.count - 1 && page < totalPages {
            fetchPopularMovies(self)
        }
    }
    
    func updateValues(movieList: MovieList) {
        page = movieList.page
        totalPages = movieList.totalPages
        let all = allMovies.value + movieList.results
        allMovies.value = all
    }
}
