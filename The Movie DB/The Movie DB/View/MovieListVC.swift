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
    @IBOutlet weak var searchBar: MovieSearchBar!
    
    lazy var viewModel: MovieListViewModel = {
        let viewModel = MovieListViewModel(MovieListService.shared)
        return viewModel
    }()
    
    lazy var searchViewModel: SearchListViewModel = {
        let viewModel = SearchListViewModel(SearchService.shared)
        return viewModel
    }()
    
    var viewModelDataSourceDel: MovieListDataSourceDelegate?
    var searchViewModelDataSourceDel: MovieListDataSourceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Movies"
        
        collectionView.register(UINib(nibName: "MovieCell", bundle: .main), forCellWithReuseIdentifier: "MovieCell")
        
        viewModelDataSourceDel = MovieListDataSourceDelegate(viewModel)
        searchViewModelDataSourceDel = MovieListDataSourceDelegate(searchViewModel)
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.dataSource = viewModelDataSourceDel
        collectionView.delegate = viewModelDataSourceDel
        
        searchBar.movieSearchBarDelegate = self
        
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
}

extension MovieListVC: MovieSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String, hasText: Bool) {
        if hasText {
            title = "Search Results"
            
            collectionView.delegate = searchViewModelDataSourceDel
            collectionView.dataSource = searchViewModelDataSourceDel
            searchViewModel.fetchMovies(query: searchBar.text ?? "")
        }
        else {
            title = "Popular Movies"
            collectionView.dataSource = viewModelDataSourceDel
            collectionView.delegate = viewModelDataSourceDel
        }
        collectionView.reloadData()
    }
}

extension MovieListVC: MovieListDataSourceDelegateProtocol {
    func openMovie(_ viewModel: MovieViewModel) {
        Router.showMovieDetailVC(from: self, viewModel: viewModel)
    }
}

