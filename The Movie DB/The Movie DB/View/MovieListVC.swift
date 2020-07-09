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
    
    func updateQuery(_ text: String?, _ isFirstResponder: Bool) {
        collectionView.showTags = isFirstResponder
        collectionView.query = text ?? ""
        if collectionView.query.isEmpty {
            title = "Popular Movies"
        }
        else {
            title = "Search Results"
        }
    }
}


extension MovieListVC: MovieListCollectionViewProtocol {
    func openMovie(_ viewModel: MovieDetailViewModel) {
        Router.showMovieDetailVC(from: self, viewModel: viewModel)
    }
    
    func tagPressed(_ tag: String) {
        searchBar.text = tag
        collectionView.query = tag
    }
}

