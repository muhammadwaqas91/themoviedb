//
//  FavoriteListVC.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/9/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit

class FavoriteListVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: MovieListCollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favorite Movies"
        
        collectionView.source = self
        collectionView.protocolDelegate = self
        collectionView.serviceType = .favorite
    }
}


extension FavoriteListVC: MovieListCollectionViewProtocol {
    func openMovie(_ viewModel: MovieDetailViewModel) {
        Router.showMovieDetailVC(from: self, viewModel: viewModel)
    }
}
