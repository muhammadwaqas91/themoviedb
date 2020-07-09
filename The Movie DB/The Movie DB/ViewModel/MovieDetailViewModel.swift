//
//  MovieDetailViewModel.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/8/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

protocol MovieDetailViewModelProtocol: MovieViewModelProtocol {
    var genreTitle: Dynamic<String?> { get }
    var duration: Dynamic<String?> { get }
    var tagline: Dynamic<String?> { get }
    var movieDetail: MovieDetail? { get }
    var service: MovieDetailServiceProtocol? { get }
    
    static func getDuration(_ duration: Int64?) -> String
}

class MovieDetailViewModel: NSObject, MovieDetailViewModelProtocol {
    
    var genreTitle: Dynamic<String?>
    
    var duration: Dynamic<String?>
    
    var isFavorite: Dynamic<Bool>
    
    var backdropPath: Dynamic<String?>
    
    var posterPath: Dynamic<String?>
    
    var title: Dynamic<String?>
    
    var releaseDate: Dynamic<String?>
    
    var tagline: Dynamic<String?>
    
    var overview: Dynamic<String?>
    
    var onErrorHandler: ((String?) -> Void)?
    
    var movie: Movie
    
    var movieDetail: MovieDetail?
    var service: MovieDetailServiceProtocol?
    init(_ movie: Movie, _ service: MovieDetailServiceProtocol?) {
        self.movie = movie
        self.service = service
        
        isFavorite = Dynamic(Favorite.isFavorite(movie.id))
        
        posterPath = Dynamic(movie.posterPath)
        backdropPath = Dynamic(movie.backdropPath)
        
        title = Dynamic(movie.title)
        releaseDate = Dynamic(MovieViewModel.getReleaseYear(movie.releaseDate))
        duration = Dynamic(MovieDetailViewModel.getDuration(0))
        
        genreTitle = Dynamic("")
        tagline = Dynamic("")
        overview = Dynamic(movie.overview)
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(add(_:)), name: Notifications.addFavorite.value, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(remove(_:)), name: Notifications.removeFavorite.value, object: nil)
    }
    
    @objc func add(_ notification: Notification) {
        guard let movie = notification.userInfo?["movie"] as? Movie else { return }
        if movie.id == self.movie.id {
            isFavorite.value = true
        }
    }
    
    @objc func remove(_ notification: Notification) {
        guard let movie = notification.userInfo?["movie"] as? Movie else { return }
        if movie.id == self.movie.id {
            isFavorite.value = false
        }
    }
    
    func fetchMovieDetail() {
        service?.getMovieDetail(movie_id: movie.id, params: [:], success: {[weak self] (movieDetail) in
            self?.movieDetail = movieDetail
            self?.updateValues(movieDetail: movieDetail)
            }, failure: {[weak self] message in
                self?.onErrorHandler?(message)
        })
    }
    
    
    func updateValues(movieDetail: MovieDetail) {
        posterPath.value = movieDetail.posterPath
        title.value = movieDetail.title
        releaseDate.value = MovieViewModel.getReleaseYear(movieDetail.releaseDate)
        
        backdropPath.value = movieDetail.backdropPath
                
        genreTitle.value = genreString()
        duration.value = MovieDetailViewModel.getDuration(movieDetail.runtime)
        tagline.value = movieDetail.tagline
        overview.value = movieDetail.overview
    }
    
    static func getDuration(_ duration: Int64?) -> String {
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
    
    func genreString() -> String {
        var genreString: String = ""
        
        for genre in movieDetail?.genres ?? [] {
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
