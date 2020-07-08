//
//  MovieViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
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
    
    var movie: Movie
    var service: MovieServiceProtocol?
    
    init(withMovie movie: Movie, service: MovieServiceProtocol?) {
        self.movie = movie
        self.service = service
        
        posterPath = Dynamic(movie.posterPath)
        title = Dynamic(movie.title)
        releaseDate = Dynamic(MovieViewModel.getReleaseYear(movie.releaseDate))
        
        isFavorite = Dynamic(Favorite.isFavorite(Int64(movie.id)))
        
        backdropPath = Dynamic(movie.backdropPath)
        
        var genreString: String = ""
        
        for genre in movie.genres ?? [] {
            if let name = genre.name {
                if genreString.count > 0 {
                    genreString = genreString + ", " + name
                }
                else {
                    genreString = name
                }
            }
        }
        
        genreTitle = Dynamic(genreString)
        duration = Dynamic(MovieViewModel.getDuration(movie.runtime))
        overviewHeading = Dynamic(movie.tagline)
        overview = Dynamic(movie.overview)
        super.init()
    }
    
    func fetchMovieDetail() {
        
        service?.getMovieDetail(movie_id: movie.id, params: [:], success: {[weak self] (movie) in
            self?.updateValues(movie: movie)
            }, failure: {[weak self] message in
                if let handler = self?.onErrorHandler {
                    handler(message)
                }
        })
    }
    
    
    func updateValues(movie: Movie) {
        posterPath.value = movie.posterPath
        title.value = movie.title
        releaseDate.value = MovieViewModel.getReleaseYear(movie.releaseDate)
        
        backdropPath.value = movie.backdropPath
                
        genreTitle.value = genreString()
        duration.value = MovieViewModel.getDuration(movie.runtime)
        overviewHeading.value = movie.tagline
        overview.value = movie.overview
    }
    
    func toggleFavorite() {
        let value = movie.toggleFavorite(isFavorite: isFavorite.value)
        if value {
            Favorite.add(Int64(movie.id))
        }
        else {
            Favorite.remove(Int64(movie.id))
        }
        isFavorite.value = value
    }
    
    func genreString() -> String {
        var genreString: String = ""
        
        for genre in movie.genres ?? [] {
            if let name = genre.name {
                if genreString.count > 0 {
                    genreString = genreString + ", " + name
                }
                else {
                    genreString = name
                }
            }
        }
        return genreString
    }
}
