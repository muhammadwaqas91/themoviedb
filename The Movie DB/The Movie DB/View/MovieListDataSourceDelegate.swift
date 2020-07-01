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
    func tagPressed(_ tag: String)
}

class MovieListDataSourceDelegate: NSObject {
    
    weak var delegate: MovieListDataSourceDelegateProtocol?
    
    var viewModel: MovieListProtocol
    
    var showTags: Bool = false {
        didSet {
            print(oldValue)
        }
    }    
    
    init(_ viewModel: MovieListProtocol) {
        self.viewModel = viewModel
    }
    
    func showHistoryTags(_ showTags: Bool) {
        self.showTags = showTags
    }
}

extension MovieListDataSourceDelegate: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil

        if kind == UICollectionView.elementKindSectionHeader {
            guard let historyTagView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryTagView", for: indexPath) as? HistoryTagView else {
                return UICollectionReusableView(frame: .zero)
            }
            
            let historyTags: [String] = ["Ali", "Abdullah", "Romeo", "Shaolin", "Jaki", "USA", "Day"]
            
            historyTagView.tagListView.removeAllTags()
            
            for i in historyTags {
                let tagView = historyTagView.tagListView.addTag(i)
                tagView.tagBackgroundColor = .lightGray
                tagView.textFont = UIFont.systemFont(ofSize: 13)
            }
            historyTagView.tagListView.reloadInputViews()
            historyTagView.delegate = self
            
            reusableview = historyTagView
        }

        if kind == UICollectionView.elementKindSectionFooter {
            let footerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath)

            reusableview = footerview
        }

        return reusableview ?? UICollectionReusableView(frame: .zero)
    }

    
    
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

extension MovieListDataSourceDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.showTags {
            return CGSize(width: collectionView.bounds.size.width, height: 120)
        }
        return .zero
    }
}

extension MovieListDataSourceDelegate: HistoryTagViewDelegate {
    func tagPressed(_ tag: String) {
        delegate?.tagPressed(tag)
    }
}
