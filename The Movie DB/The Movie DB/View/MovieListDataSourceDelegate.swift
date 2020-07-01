//
//  MovieListDataSourceDelegate.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit


protocol MovieListDataSourceDelegateProtocol: NSObjectProtocol {
    func openMovie(_ viewModel: MovieViewModel)
}

class MovieListDataSourceDelegate: NSObject {
    
    weak var delegate: MovieListDataSourceDelegateProtocol?
    
    var viewModel: MovieListProtocol
    
    init(_ viewModel: MovieListProtocol) {
        self.viewModel = viewModel
    }
}


extension MovieListDataSourceDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allMovies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let array = viewModel.allMovies.value
        let movie =  array[indexPath.row]
        
        cell.viewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        
        return cell
    }
}

extension MovieListDataSourceDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.fetchMovies(after:indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) is MovieCell else {
            return
        }
        let array = viewModel.allMovies.value
        
        let movie =  array[indexPath.row]
            
        let newViewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        delegate?.openMovie(newViewModel)
    }
}
