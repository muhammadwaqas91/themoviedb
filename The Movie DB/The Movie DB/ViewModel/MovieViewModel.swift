//
//  MovieViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation

protocol MovieViewModelProtocol: ErrorHandlerProtocol {
    var movie: Movie { get }
    var posterPath: Dynamic<String?> { get }
    var title: Dynamic<String?> { get }
    var releaseDate: Dynamic<String?> { get }
    var isFavorite: Dynamic<Bool> { get }
    
    var backdropPath: Dynamic<String?> { get }
    var genreTitle: Dynamic<String?> { get }
    var overviewHeading: Dynamic<String?> { get }
    var overview: Dynamic<String?> { get }
    
    var onErrorHandler: ((String?) -> Void)? { get }
    
    func toggleFavorite()
    func getFullPosterPath() -> String?
    func getFullBackdropPath() -> String?
    static func getDuration(_ duration: Int?) -> String
    static func getReleaseYear(_ releaseDate: String?) -> String
}

extension MovieViewModelProtocol {
    
    func getFullPosterPath() -> String? {
        
        if let images = APIManager.configuration?.images, let first = images.posterSizes.first, let path = posterPath.value {
            let fullPath = images.baseUrl + first + path
            return fullPath
        }
        return nil
    }
    
    func getFullBackdropPath() -> String? {
        
        if let images = APIManager.configuration?.images, let first = images.backdropSizes.first, let path = backdropPath.value {
            let fullPath = images.baseUrl + first + path
            return fullPath
        }
        return nil
    }
    
    private static func secondsToHoursMinutesSeconds (_ seconds : Int) -> (h: Int, m: Int, s: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func getReleaseYear(_ releaseDate: String?) -> String {
        guard let releaseDate = releaseDate else {
            return ""
        }
        let releaseYear: String = String(releaseDate.split(separator: "-").first ?? "")
        return releaseYear
    }
    
    static func getDuration(_ duration: Int?) -> String {
        guard let duration = duration else {
            return "0s"
        }
        var formattedString = ""
        let time = secondsToHoursMinutesSeconds(duration)
        if time.h > 0 {
            formattedString = "\(time.h)h \(time.m)m \(time.s)s"
        }
        else if time.m > 0 {
            formattedString = "\(time.m)m \(time.s)s"
        }
        else {
            formattedString = "\(time.s)s"
        }
        
        return formattedString
    }
}
 
class MovieViewModel: NSObject, MovieViewModelProtocol {
    
    var movie: Movie
    var posterPath: Dynamic<String?>
    var title: Dynamic<String?>
    var releaseDate: Dynamic<String?>
    var isFavorite: Dynamic<Bool>
    
    var backdropPath: Dynamic<String?>
    var genreTitle: Dynamic<String?>
    var duration: Dynamic<String?>
    var overviewHeading: Dynamic<String?>
    var overview: Dynamic<String?>
    var onErrorHandler: ((String?) -> Void)?
    
    init(withMovie movie: Movie) {
        self.movie = movie
        
        posterPath = Dynamic(movie.posterPath)
        title = Dynamic(movie.title)
        releaseDate = Dynamic(MovieViewModel.getReleaseYear(movie.releaseDate))
        isFavorite = Dynamic(false)
        
        backdropPath = Dynamic(movie.backdropPath)
        
        var genreString: String = ""
        
        for genre in movie.genres ?? [] {
            if let name = genre.name {
                genreString = genreString + " " + name
            }
        }
        
        genreTitle = Dynamic(genreString)
        duration = Dynamic(MovieViewModel.getDuration(movie.runtime))
        overviewHeading = Dynamic(movie.tagline)
        overview = Dynamic(movie.overview)
    }
    
    func fetchMovieDetail() {
        APIManager.getMovieDetail(movie_id: movie.id, success: {[weak self] (movie) in
            self?.updateValues(movie: movie)
            }, failure: { message in
                if let handler = self.onErrorHandler {
                    handler(message)
                }
        })
    }
    
    func updateValues(movie: Movie) {
        posterPath.value = movie.posterPath
        title.value = movie.title
        releaseDate.value = MovieViewModel.getReleaseYear(movie.releaseDate)
        
        isFavorite.value = movie.isFavorite ?? false
        
        backdropPath.value = movie.backdropPath
        
        var genreString: String = ""
        
        for genre in movie.genres ?? [] {
            if let name = genre.name {
                genreString += name
            }
        }
        
        genreTitle.value = genreString
        duration.value = MovieViewModel.getDuration(movie.runtime)
        overviewHeading.value = movie.tagline
        overview.value = movie.overview
    }
    
    
    func toggleFavorite() {
        isFavorite.value = movie.toggleFavorite(isFavorite: isFavorite.value)
    }
}
