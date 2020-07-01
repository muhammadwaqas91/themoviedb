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
        
        collectionView.register(UINib(nibName: "HistoryTagView", bundle: .main), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "HistoryTagView")
                                
        
        viewModelDataSourceDel = MovieListDataSourceDelegate(viewModel)
        searchViewModelDataSourceDel = MovieListDataSourceDelegate(searchViewModel)
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.dataSource = viewModelDataSourceDel
        collectionView.delegate = viewModelDataSourceDel
        
        viewModelDataSourceDel?.delegate = self
        searchViewModelDataSourceDel?.delegate = self
        
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
    
    
    func showHistoryTags(_ showTags: Bool, _ continueSearch: Bool) {
        
        viewModelDataSourceDel?.showTags = showTags
        searchViewModelDataSourceDel?.showTags = showTags
        
        if continueSearch {
            title = "Search Results"
        }
        else {
            title = "Popular Movies"
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchBarTextDidChange(_ text: String, _ hasText: Bool) {
        viewModelDataSourceDel?.showTags = false
        searchViewModelDataSourceDel?.showTags = false
        if hasText {
            title = "Search Results"
            collectionView.delegate = searchViewModelDataSourceDel
            collectionView.dataSource = searchViewModelDataSourceDel
            searchViewModel.fetchMovies(query: searchBar.text ?? "")
        }
        else {
//            viewModelDataSourceDel?.showTags = true
//            searchViewModelDataSourceDel?.showTags = true
            title = "Popular Movies"
            collectionView.dataSource = viewModelDataSourceDel
            collectionView.delegate = viewModelDataSourceDel
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}


extension MovieListVC: MovieListDataSourceDelegateProtocol {
    func openMovie(_ viewModel: MovieViewModel) {
        Router.showMovieDetailVC(from: self, viewModel: viewModel)
    }
    
    func tagPressed(_ tag: String) {
        searchBar.text = tag
        collectionView.delegate = searchViewModelDataSourceDel
        collectionView.dataSource = searchViewModelDataSourceDel
        searchViewModel.fetchMovies(query: searchBar.text ?? "")
    }
}

