//
//  MovieListVC.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    // MARK: - Life Cycle
    deinit {
        print("deinit \(self)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(self) didReceiveMemoryWarning")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(self) viewDidLoad")
    }
}

class MovieListVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: MovieListCollectionView!
    @IBOutlet weak var searchBar: MovieSearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Movies"
        
        collectionView.source = self
        collectionView.protocolDelegate = self
        
        searchBar.movieSearchBarDelegate = self
    }
}

extension MovieListVC: MovieSearchBarDelegate {
    
    func showHistoryTags(_ continueSearch: Bool) {
        collectionView.isSearching = continueSearch
    }
    
    func searchBarTextDidChange(_ text: String, _ hasText: Bool) {
        collectionView.query = text
        
        if hasText {
            title = "Search Results"
        }
        else {
            title = "Popular Movies"
        }
    }
}


extension MovieListVC: MovieListCollectionViewProtocol {
    func openMovie(_ viewModel: MovieViewModel) {
        Router.showMovieDetailVC(from: self, viewModel: viewModel)
    }
    
    func tagPressed(_ tag: String) {
        searchBar.text = tag
        collectionView.query = tag
    }
}

