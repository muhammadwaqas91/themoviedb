//
//  PopularMoviesVC.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
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

class PopularMoviesVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var viewModel : MovieListViewModel = {
        let viewModel = MovieListViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Movies"
        
        collectionView.register(UINib(nibName: "MovieCell", bundle: .main), forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.allMovies.bind { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel.onErrorHandler = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        self.viewModel.fetchMovies()
        
        setFlowLayoutSize()
    }
    
    private func setFlowLayoutSize() {
        collectionView.collectionViewLayout.invalidateLayout()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        layout.itemSize = CGSize(width: width * 0.45, height: height * 0.40)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}

extension PopularMoviesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allMovies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = viewModel.allMovies.value[indexPath.row]
        cell.viewModel = MovieViewModel(withMovie: movie)
        
        return cell
    }
}

extension PopularMoviesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.allMovies.value.count - 1 && viewModel.page < viewModel.totalPages {
            viewModel.fetchMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) is MovieCell else {
            return
        }
            
        let movie = viewModel.allMovies.value[indexPath.row]
        let newViewModel = MovieViewModel(withMovie: movie)
        Router.showMovieDetailVC(from: self, viewModel: newViewModel)
        
    }
}
