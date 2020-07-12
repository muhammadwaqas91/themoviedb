//
//  Favorite.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/9/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation

extension Favorite {
    
    static func isFavorite(_ id: Int64) -> Bool {
        guard let _ = CoreDataManager.fetch(Entity.Favorite, id) as? Favorite else {
            return false
        }
        return true
    }
    
    static func add(_ movie: Movie) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(movie)
            let predicate = NSPredicate(format: "id == %ld", movie.id)
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let _ = CoreDataManager.save(json, Entity.Favorite, predicate) else {
                return false
            }
            NotificationCenter.default.post(name: Notifications.addFavorite.value, object: nil, userInfo: ["movie": movie])
            return true
            
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    static func remove(_ movie: Movie) {
        let predicate = NSPredicate(format: "id == %ld", movie.id)
        CoreDataManager.delete(Entity.Favorite, predicate)
        
        NotificationCenter.default.post(name: Notifications.removeFavorite.value, object: nil, userInfo: ["movie": movie])
    }
    
    static func favorites() -> [Movie] {
        guard let favorites = CoreDataManager.fetchList(Entity.Favorite) as? [Favorite] else {
            return []
        }
        
        var movies: [Movie] = []
        for fav in favorites {
            let movie = Movie(popularity: fav.popularity, voteCount: fav.voteCount, video: fav.video, posterPath: fav.posterPath, id: fav.id, adult: fav.adult, backdropPath: fav.backdropPath, originalLanguage: fav.originalLanguage, originalTitle: fav.originalTitle, genreIds: [], title: fav.title, voteAverage: fav.voteAverage, overview: fav.overview, releaseDate: fav.releaseDate, isFavorite: fav.isFavorite)
            
            movies.append(movie)
        }
        
        return movies
    }
}

extension Favorite: CodableManagedObjectProtocol {
    
    public enum CodingKeys: String, CodingKey {
        case id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
    
    public func setValues(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
    }
}
