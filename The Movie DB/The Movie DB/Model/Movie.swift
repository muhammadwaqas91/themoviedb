//
//  Movie.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

// MARK: - Movie

protocol MovieProtocol {
    var adult: Bool? { get }
    var backdropPath: String? { get }
    var budget: Int? { get }
    
    var homepage: String? { get }
    var id: Int { get }
    var imdbId: String? { get }
    var originalLanguage: String? { get }
    var originalTitle: String? { get }
    var overview: String? { get }
    var popularity: Double? { get }
    var posterPath: String? { get }
    
    var releaseDate: String? { get }
    var revenue: Int? { get }
    var runtime: Int? { get }
    
    var status: String? { get }
    var tagline: String? { get }
    var title: String? { get }
    var video: Bool? { get }
    var voteAverage: Double? { get }
    var voteCount: Int? { get }
        
    var isFavorite: Bool? { get set }
    
    var genres: [Genre]? { get }
    var spokenLanguages: [SpokenLanguage]? { get }
    var productionCompanies: [ProductionCompany]? { get }
    var productionCountries: [ProductionCountry]? { get }
    
    mutating func toggleFavorite(isFavorite: Bool) -> Bool
}

extension MovieProtocol {
    mutating func toggleFavorite(isFavorite: Bool) -> Bool {
        self.isFavorite = !isFavorite
        return self.isFavorite!
    }
}

struct Movie: Decodable, MovieProtocol, Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    var genres: [Genre]?
    
    var spokenLanguages: [SpokenLanguage]?
    
    var productionCompanies: [ProductionCompany]?
    
    var productionCountries: [ProductionCountry]?
    
    var isFavorite: Bool?
    
    var adult: Bool?
    
    var backdropPath: String?
    
    var budget: Int?
    
    var homepage: String?
    
    var id: Int
    
    var imdbId: String?
    
    var originalLanguage: String?
    
    var originalTitle: String?
    
    var overview: String?
    
    var popularity: Double?
    
    var posterPath: String?
    
    var releaseDate: String?
    
    var revenue: Int?
    
    var runtime: Int?
    
    var status: String?
    
    var tagline: String?
    
    var title: String?
    
    var video: Bool?
    
    var voteAverage: Double?
    
    var voteCount: Int?
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
