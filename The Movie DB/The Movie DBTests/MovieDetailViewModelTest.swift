//
//  MovieDetailViewModelTest.swift
//  The Movie DBTests
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import XCTest
@testable import The_Movie_DB

class MovieDetailViewModelTest: XCTestCase {
    var movie : Movie?
    var service : MovieDetailServiceProtocol?
    var viewModel : MovieDetailViewModel?
    fileprivate var mockService : MockService?
    
    override func setUp() {
        super.setUp()
        
        self.movie = Movie(popularity: 0.0, voteCount: 0, video: false, posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", id: 181812, adult: false, backdropPath: "", originalLanguage: "English", originalTitle: "Avengers", genreIds: [], title: "Avengers", voteAverage: 0.0, overview: "Overview here", releaseDate: "2017-12-12", isFavorite: false)
        
        self.service = MovieDetailService.shared
        
        self.viewModel = MovieDetailViewModel(movie!, service)
        
        self.mockService = MockService()
    }
    
    override func tearDown() {
        self.movie = nil
        self.service = nil
        self.viewModel = nil
        self.mockService = nil
        
        super.tearDown()
    }
    
    func testFetchMovieDetail() {
        
        let expectation = XCTestExpectation(description: "Movie List Fetch")
        
        
        // giving a service mocking movie detail
        let movieDetail = MovieDetail(budget: 0, homepage: "", imdbId: "", revenue: 0, runtime: 120, status: "", tagline: "Tag line", video: false, voteCount: 0, genres: [], spokenLanguages: [], productionCompanies: [], productionCountries: [], popularity: 0.0, posterPath: "/db32LaOibwEliAmSL2jjDF6oDdj.jpg", id: 181812, adult: false, backdropPath: "", originalLanguage: "", originalTitle: "", genreIds: [], title: "", voteAverage: 0.0, overview: "", releaseDate: "2017-12-12", isFavorite: false)
        
        mockService?.movieDetail = movieDetail
        
        viewModel?.onErrorHandler = { _ in
            XCTAssert(false, "ViewModel should not be able to fetch without service")
        }
        
        viewModel?.posterPath.bind { (text) in
            expectation.fulfill()
        }
        
        viewModel?.duration.bind { (text) in
            expectation.fulfill()
        }
        
        viewModel?.fetchMovieDetail()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

fileprivate struct MockService: MovieDetailServiceProtocol {
    var movieDetail : MovieDetail?
    mutating func getMovieDetail(movie_id: Int64, params: [String : Any], success: @escaping (MovieDetail) -> (), failure: ((String?) -> Void)?) {
        if let movieDetail = movieDetail {
            success(movieDetail)
        }
        else {
            failure?("getMovieDetail Failed")
        }
    }
}
