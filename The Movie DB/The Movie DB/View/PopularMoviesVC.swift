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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var hasText: Bool {
        if let text = searchBar.text, !text.isEmpty {
            self.title = "Search Results"
            return true
        }
        self.title = "Popular Movies"
        return false
    }
    
    lazy var viewModel : MovieListViewModel = {
        let viewModel = MovieListViewModel(MovieListService.shared, SearchService.shared)
        return viewModel
    }()
    
    lazy var searchViewModel : SearchListViewModel = {
        let viewModel = SearchListViewModel(SearchService.shared)
        return viewModel
    }()
    
    private func bindViewModels() {
        
        viewModel.allMovies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onErrorHandler = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        searchViewModel.allMovies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        searchViewModel.page = 1
        searchViewModel.onErrorHandler = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Movies"
        
        collectionView.register(UINib(nibName: "MovieCell", bundle: .main), forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        
        bindViewModels()
        
        viewModel.fetchMovies(after: 0)
        
        setFlowLayoutSize()
    }
    
    private func setFlowLayoutSize() {
        collectionView.collectionViewLayout.invalidateLayout()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        layout.itemSize = CGSize(width: width * 0.45, height: height * 0.45)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}

extension MovieListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasText ? searchViewModel.allMovies.value.count : viewModel.allMovies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let array = hasText ? searchViewModel.allMovies.value : viewModel.allMovies.value
        
        let movie =  array[indexPath.row]
        
        cell.viewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        
        return cell
    }
}

extension MovieListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        hasText ?  searchViewModel.fetchMovies(after:indexPath.item) : viewModel.fetchMovies(after:indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) is MovieCell else {
            return
        }
        let array = hasText ? searchViewModel.allMovies.value : viewModel.allMovies.value
        
        let movie =  array[indexPath.row]
            
        let newViewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        Router.showMovieDetailVC(from: self, viewModel: newViewModel)
    }
}

extension MovieListVC: UISearchBarDelegate {
    
    // called when text starts editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        if hasText {
            
        }
    }
    
    // called when text ends editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        
    }

     // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: searchText")
        if hasText {
            searchViewModel.fetchMovies(query: searchBar.text ?? "")
        }
        else {
            collectionView.reloadData()
        }
    }
    
     // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }

     // called when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        collectionView.reloadData()
    }
}
