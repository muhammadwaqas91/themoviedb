//
//  MovieListViewModelTest.swift
//  The Movie DBTests
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import XCTest
@testable import The_Movie_DB

class MovieListViewModelTest: XCTestCase {
    
    var viewModel : MovieListViewModel!
    fileprivate var mockService : MockService!
    
    override func setUp() {
        super.setUp()
        self.mockService = MockService()
        self.viewModel = MovieListViewModel(.popular)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.mockService = nil
        super.tearDown()
    }
    
    func testFetchMovies() {
        let expectation = XCTestExpectation(description: "Movie List Fetch")
        
        var movieList: [Movie] = []
        for _ in 1...10 {
            
            let movie = Movie(popularity: 0.0, voteCount: 0, video: false, posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", id: 181812, adult: false, backdropPath: "", originalLanguage: "English", originalTitle: "Avengers", genreIds: [], title: "Avengers", voteAverage: 0.0, overview: "Overview here", releaseDate: "2017-12-12", isFavorite: false)
            
            movieList.append(movie)
        }
        
        // giving a service mocking movies
        mockService.movieList = MovieList(page: 1, totalResults: 2, totalPages: 1, results: movieList)
        
        viewModel.onErrorHandler = { _ in
            XCTAssert(false, "ViewModel should not be able to fetch without service")
        }
        
        viewModel.newMovies.bind { (movieList) in
            expectation.fulfill()
        }
        
        viewModel.fetchMovies(after: 0)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate struct MockService : MovieListServiceProtocol {
    
    var movieList : MovieList?
    
    mutating func fetchMovies(_ serviceType: ServiceType, _ params: [String : Any], success: @escaping (MovieList) -> (), failure: ((String?) -> Void)?) {
        if let movieList = movieList {
            success(movieList)
        }
        else {
            failure?("fetch Failed")
        }
    }
}

