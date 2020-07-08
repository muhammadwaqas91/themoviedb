//
//  MovieDetail.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/8/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieDetailProtocol: MovieProtocol {
    var budget: Int? { get }
    var homepage: String? { get }
    var imdbId: String? { get }
    var revenue: Int? { get }
    var runtime: Int? { get }
    var status: String? { get }
    var tagline: String? { get }
    
    var genres: [Genre]? { get }
    var spokenLanguages: [SpokenLanguage]? { get }
    var productionCompanies: [ProductionCompany]? { get }
    var productionCountries: [ProductionCountry]? { get }
}

struct MovieDetail: Decodable, MovieDetailProtocol {
    var budget: Int?
    
    var homepage: String?
    
    var imdbId: String?
    
    var revenue: Int?
    
    var runtime: Int?
    
    var status: String?
    
    var tagline: String?
    
    var video: Bool?
    
    var voteCount: Int?
    
    var genres: [Genre]?
    
    var spokenLanguages: [SpokenLanguage]?
    
    var productionCompanies: [ProductionCompany]?
    
    var productionCountries: [ProductionCountry]?
    
    var popularity: Double?
    
    var posterPath: String?
    
    var id: Int
    
    var adult: Bool?
    
    var backdropPath: String?
    
    var originalLanguage: String?
    
    var originalTitle: String?
    
    var genreIds: [Int]?
    
    var title: String?
    
    var voteAverage: Double?
    
    var overview: String?
    
    var releaseDate: String?
    
    var isFavorite: Bool?
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

enum OriginalLanguage: String, Decodable {
    case en
    case fr
    case ko
    case sv
}
