//
//  APIManager_PopularMovies.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/28/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

// MARK: - Get Popular

extension APIManager {
    
    // MARK: - Popular
    struct MovieList: Decodable {
        let page, totalResults, totalPages: Int
        let results: [Movie]
    }

    // MARK: - Movie
    struct Movie: Decodable {
        let popularity: Double?
        let voteCount: Int?
        let video: Bool?
        let posterPath: String?
        let id: Int
        let adult: Bool?
        let backdropPath: String?
//        let originalLanguage: OriginalLanguage?
        let originalTitle: String?
        let genreIds: [Int]?
        let title: String?
        let voteAverage: Double?
        let overview, releaseDate: String?
    }

    enum OriginalLanguage: String, Decodable {
        case en
        case fr
        case ko
        case sv
    }
    
    static func getPopularMovies(params: [String: Any] = [:], success:@escaping (MovieList) -> (), failure: @escaping (String?) -> Void) {
        
        APIManager.request(endPoint: Constants.popular, params:params, success: { (movies: MovieList) in
            success(movies)
        }, failure: { message in
            failure(message)
        })
    }
}


// MARK: - Get Details

extension APIManager {
    // MARK: - MovieDetails
    struct MovieDetails: Decodable {
        var adult: Bool?
        var backdropPath: String?
        var budget: Int?
        var genres: [Genre]?
        var homepage: String?
        var id: Int
        var imdbId, originalLanguage, originalTitle, overview: String?
        var popularity: Double?
        var posterPath: String?
        var productionCompanies: [ProductionCompany]?
        var productionCountries: [ProductionCountry]?
        var releaseDate: String?
        var revenue, runtime: Int?
        var spokenLanguages: [SpokenLanguage]?
        var status, tagline, title: String?
        var video: Bool?
        var voteAverage, voteCount: Int?
    }

    // MARK: - Genre
    struct Genre: Decodable {
        var id: Int?
        var name: String?
    }

    // MARK: - ProductionCompany
    struct ProductionCompany: Decodable {
        var id: Int?
        var logoPath: String?
        var name, originCountry: String?
    }

    // MARK: - ProductionCountry
    struct ProductionCountry: Decodable {
        var iso3166_1, name: String?
    }

    // MARK: - SpokenLanguage
    struct SpokenLanguage: Decodable {
        var iso639_1, name: String?
    }
    
    
    // movie_id
    
    static func getMovieDetails(movie_id: Int, params: [String: Any] = [:], success:@escaping (MovieDetails) -> (), failure: @escaping (String?) -> Void) {
        
        APIManager.request(endPoint: Constants.movie + "/\(movie_id)", params: params, success: { (details: MovieDetails) in
            success(details)
        }, failure: { message in
            failure(message)
        })
    }
}
