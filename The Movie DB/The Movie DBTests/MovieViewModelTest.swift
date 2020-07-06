//
//  MovieViewModelTest.swift
//  The Movie DBTests
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import XCTest
@testable import The_Movie_DB

class MovieViewModelTest: XCTestCase {
    
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
    
    
    var movie : Movie!
    var viewModel : MovieViewModel!
    fileprivate var mockService : MockService!
    
    override func setUp() {
        super.setUp()
        self.mockService = MockService()
        self.movie = Movie(genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Action2"), Genre(id: 3, name: "Action3")], spokenLanguages: [SpokenLanguage(iso639_1: "L1", name: "language"), SpokenLanguage(iso639_1: "L2", name: "language2")], productionCompanies: [], productionCountries: [], isFavorite: false, adult: false, backdropPath: nil, budget: nil, homepage: nil, id: 181812, imdbId: nil, originalLanguage: "English", originalTitle: "Avengers", overview: "This is OverView", popularity: nil, posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", releaseDate: "2017", revenue: nil, runtime: 200, status: nil, tagline: "tagline", title: "title", video: nil, voteAverage: nil, voteCount: nil)
        
        self.viewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
    }
    
    override func tearDown() {
        self.mockService = nil
        self.movie = nil
        self.viewModel = nil
        super.tearDown()
    }
    
    func testFetchMovieDetail() {
        
        let expectation = XCTestExpectation(description: "Movie List Fetch")
        
        
        // giving a service mocking movie
        let movie = Movie(genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Action2"), Genre(id: 3, name: "Action3")], spokenLanguages: [SpokenLanguage(iso639_1: "L1", name: "language"), SpokenLanguage(iso639_1: "L2", name: "language2")], productionCompanies: [], productionCountries: [], isFavorite: false, adult: false, backdropPath: nil, budget: nil, homepage: nil, id: 181812, imdbId: nil, originalLanguage: "English", originalTitle: "Avengers", overview: "This is OverView", popularity: nil, posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", releaseDate: "2017", revenue: nil, runtime: 200, status: nil, tagline: "tagline", title: "title", video: nil, voteAverage: nil, voteCount: nil)
        
        mockService.movie = movie
        
        viewModel.onErrorHandler = { _ in
            XCTAssert(false, "ViewModel should not be able to fetch without service")
        }
        
        viewModel.posterPath.bind { (text) in
            expectation.fulfill()
        }
        
        viewModel.duration.bind { (text) in
            expectation.fulfill()
        }
        
        viewModel.fetchMovieDetail()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate class MockService : MovieServiceProtocol {
    var movie : Movie?
    func getMovieDetail(movie_id: Int, params: [String : Any], success: @escaping (Movie) -> (), failure: ((String?) -> Void)?) {
        if let movie = movie {
            success(movie)
        }
        else {
            if let failure = failure {
                failure("getMovieDetail Failed")
            }
        }
    }
}
