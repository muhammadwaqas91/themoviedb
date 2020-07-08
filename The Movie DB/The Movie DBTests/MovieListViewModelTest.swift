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
    
    //    override func setUpWithError() throws {
    //        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    }
    //
    //    override func tearDownWithError() throws {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //    }
    //
    //    func testExample() throws {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //    }
    //
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
    
    var viewModel : MovieListViewModel!
    fileprivate var mockService : MockService!
    
    override func setUp() {
        super.setUp()
        self.mockService = MockService()
        self.viewModel = MovieListViewModel(MovieListService.shared)
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
        
        viewModel.allMovies.bind { (movieList) in
            expectation.fulfill()
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
    
    func fetchPopularMovies(params: [String: Any], success:@escaping (MovieList) -> (), failure: ((String?) -> Void)?) {
        if let movieList = movieList {
            success(movieList)
        }
        else {
            if let failure = failure {
                failure("fetchPopularMovies Failed")
            }
        }
    }
}

