//
//  MovieDetail.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/8/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieDetailProtocol: MovieProtocol {
    var budget: Int64? { get }
    var homepage: String? { get }
    var imdbId: String? { get }
    var revenue: Int64? { get }
    var runtime: Int64? { get }
    var status: String? { get }
    var tagline: String? { get }
    
    var genres: [Genre]? { get }
    var spokenLanguages: [SpokenLanguage]? { get }
    var productionCompanies: [ProductionCompany]? { get }
    var productionCountries: [ProductionCountry]? { get }
}

struct MovieDetail: Decodable, MovieDetailProtocol {
    var budget: Int64?
    
    var homepage: String?
    
    var imdbId: String?
    
    var revenue: Int64?
    
    var runtime: Int64?
    
    var status: String?
    
    var tagline: String?
    
    var video: Bool?
    
    var voteCount: Int64?
    
    var genres: [Genre]?
    
    var spokenLanguages: [SpokenLanguage]?
    
    var productionCompanies: [ProductionCompany]?
    
    var productionCountries: [ProductionCountry]?
    
    var popularity: Double?
    
    var posterPath: String?
    
    var id: Int64
    
    var adult: Bool?
    
    var backdropPath: String?
    
    var originalLanguage: String?
    
    var originalTitle: String?
    
    var genreIds: [Int64]?
    
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
