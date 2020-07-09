//
//  MovieViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieViewModelProtocol: ErrorHandlerProtocol {
    var movie: Movie { get set }
    var isFavorite: Dynamic<Bool> { get }
    
    var backdropPath: Dynamic<String?> { get }
    var posterPath: Dynamic<String?> { get }
    var title: Dynamic<String?> { get }
    var releaseDate: Dynamic<String?> { get }
    
    var overview: Dynamic<String?> { get }
    
    var onErrorHandler: ((String?) -> Void)? { get }
    
    mutating func toggleFavorite()
    func getFullPosterPath() -> String?
    func getFullBackdropPath() -> String?
    
    static func getReleaseYear(_ releaseDate: String?) -> String
}

extension MovieViewModelProtocol {
    func getFullPosterPath() -> String? {
        
        if let images = ConfigurationService.shared.configuration?.images, let first = images.posterSizes?.first, let path = posterPath.value, let baseUrl = images.baseUrl {
            let fullPath = baseUrl + first + path
            return fullPath
        }
        return nil
    }
    
    func getFullBackdropPath() -> String? {
        
        if let images = ConfigurationService.shared.configuration?.images, let first = images.backdropSizes?.first, let path = backdropPath.value, let baseUrl = images.baseUrl {
            let fullPath = baseUrl + first + path
            return fullPath
        }
        return nil
    }
    
    static func secondsToHoursMinutesSeconds (_ seconds : Int64) -> (h: Int64, m: Int64, s: Int64) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func getReleaseYear(_ releaseDate: String?) -> String {
        guard let releaseDate = releaseDate else {
            return ""
        }
        let releaseYear: String = String(releaseDate.split(separator: "-").first ?? "")
        return releaseYear
    }
    
    mutating func toggleFavorite() {
        let value = movie.toggleFavorite(isFavorite: isFavorite.value)
        if value {
            isFavorite.value = Favorite.add(movie)
        }
        else {
            Favorite.remove(movie)
            isFavorite.value = false
        }
    }
}
 
class MovieViewModel: NSObject, MovieViewModelProtocol {
    
    
    var posterPath: Dynamic<String?>
    var title: Dynamic<String?>
    var releaseDate: Dynamic<String?>
    var isFavorite: Dynamic<Bool>
    
    var backdropPath: Dynamic<String?>
    var overview: Dynamic<String?>
    var onErrorHandler: ((String?) -> Void)?
    
    var movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
        
        isFavorite = Dynamic(Favorite.isFavorite(Int64(movie.id)))
        
        posterPath = Dynamic(movie.posterPath)
        backdropPath = Dynamic(movie.backdropPath)
        title = Dynamic(movie.title)
        releaseDate = Dynamic(MovieViewModel.getReleaseYear(movie.releaseDate))
        overview = Dynamic(movie.overview)
        super.init()
    }
    
    func updateValues(movie: Movie) {
        posterPath.value = movie.posterPath
        backdropPath.value = movie.backdropPath
        title.value = movie.title
        releaseDate.value = MovieViewModel.getReleaseYear(movie.releaseDate)
        overview.value = movie.overview
    }
}
