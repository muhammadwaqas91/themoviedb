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
    var popularity: Double? { get }
    var voteCount: Int64? { get }
    var video: Bool? { get }
    var posterPath: String? { get }
    var id: Int64 { get }
    var adult: Bool? { get }
    var backdropPath: String? { get }
    var originalLanguage: String? { get }
    var originalTitle: String? { get }
    var genreIds: [Int64]? { get }
    var title: String? { get }
    var voteAverage: Double? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
        
    var isFavorite: Bool? { get set }
    
    mutating func toggleFavorite(isFavorite: Bool) -> Bool
}


extension MovieProtocol {
    mutating func toggleFavorite(isFavorite: Bool) -> Bool {
        self.isFavorite = !isFavorite
        return self.isFavorite!
    }
}

struct Movie: Codable, MovieProtocol, Equatable {
    var popularity: Double?
    
    var voteCount: Int64?
    
    var video: Bool?
    
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
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
