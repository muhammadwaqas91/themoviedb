//
//  MovieListCollectionView.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import Foundation
import UIKit


protocol MovieListCollectionViewProtocol: NSObjectProtocol {
    func openMovie(_ viewModel: MovieViewModel)
    func tagPressed(_ tag: String)
}

class MovieListCollectionView: UICollectionView {
    
    weak var source: UIViewController?
    weak var protocolDelegate: MovieListCollectionViewProtocol?
    
    private var popularViewModel = MovieListViewModel(MovieListService.shared)
    private var searchViewModel = SearchListViewModel(SearchService.shared)
    
    private var viewModel: MovieListProtocol {
        get {
            if isSearching {
                return searchViewModel
            }
            return popularViewModel
        }
    }
    
    var query: String = "" {
        didSet {
            if query.isEmpty {
                isSearching = false
                showTags = true
            }
            else {
                showTags = false
                isSearching = true
                searchViewModel.query = query
            }
        }
    }
    
    var isSearching: Bool = false {
        didSet {
            if isSearching {
            }
            else {
                reloadData()
            }
        }
    }
    
    var showTags: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(UINib(nibName: "MovieCell", bundle: .main), forCellWithReuseIdentifier: "MovieCell")
        register(UINib(nibName: "HistoryTagView", bundle: .main), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "HistoryTagView")
        
        dataSource = self
        delegate = self
        keyboardDismissMode = .onDrag
        
        setFlowLayoutSize()
        bindViewModels()
        
        viewModel.fetchMovies(after: 0)
    }
    
    private func setFlowLayoutSize() {
        collectionViewLayout.invalidateLayout()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        let height = frame.size.height
        let width = frame.size.width
        layout.itemSize = CGSize(width: width * 0.45, height: height * 0.45)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
    }
    
    private func bindViewModels() {
        popularViewModel.newMovies.bind { [weak self] _ in
            DispatchQueue.main.async {
                
                guard let newMovies = self?.popularViewModel.newMovies.value, let allMovies = self?.popularViewModel.allMovies.value, newMovies.count > 0 && allMovies.count > newMovies.count  else {
                    UIView.animate(withDuration: 0) {[weak self] in
                        self?.performBatchUpdates({
                            self?.reloadSections(IndexSet(integer: 1))
                        }, completion: nil)
                    }
                    
                    return
                }
                
                self?.performBatchUpdates({
                    let indexes = allMovies.findIndexes(newMovies)
                    let indexPaths: [IndexPath] = indexes.map({IndexPath(item: $0, section: 1)})
                    self?.insertItems(at: indexPaths)
                }, completion: nil)
            }
        }
        
        popularViewModel.onErrorHandler = { [weak self] message in
            self?.source?.showAlert(message: message)
        }
        
        searchViewModel.newMovies.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let newMovies = self?.searchViewModel.newMovies.value, let allMovies = self?.searchViewModel.allMovies.value, newMovies.count > 0 && allMovies.count > newMovies.count  else {
                    UIView.animate(withDuration: 0) {[weak self] in
                        self?.performBatchUpdates({
                            self?.reloadSections(IndexSet(integer: 1))
                        }, completion: nil)
                    }
                    return
                }
                
                self?.performBatchUpdates({
                    let indexes = allMovies.findIndexes(newMovies)
                    let indexPaths: [IndexPath] = indexes.map({IndexPath(item: $0, section: 1)})
                    self?.insertItems(at: indexPaths)
                }, completion: nil)
            }
        }
        searchViewModel.page = 1
        searchViewModel.onErrorHandler = { [weak self] message in
            self?.source?.showAlert(message: message)
        }
    }
}

extension MovieListCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let historyTagView = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryTagView", for: indexPath) as? HistoryTagView else {
                    return UICollectionReusableView(frame: .zero)
                }
                
                historyTagView.tagListView.removeAllTags()
                
                for i in History.tags() {
                    if let tag = i.tag {
                        let tagView = historyTagView.tagListView.addTag(tag)
                        tagView.tagBackgroundColor = .lightGray
                        tagView.textFont = UIFont.systemFont(ofSize: 13)
                    }
                }
                
                historyTagView.delegate = self
                
                historyTagView.tagListView.reloadInputViews()
                
                reusableview = historyTagView
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                let footerview = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath)
                
                reusableview = footerview
            }
            
            return reusableview ?? UICollectionReusableView(frame: .zero)
        }
        
        return UICollectionReusableView(frame: .zero)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return viewModel.allMovies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let array = viewModel.allMovies.value
        let movie =  array[indexPath.row]
        
        cell.viewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        
        return cell
    }
}

extension MovieListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.fetchMovies(after:indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) is MovieCell else {
            return
        }
        let array = viewModel.allMovies.value
        
        let movie =  array[indexPath.row]
        
        let newViewModel = MovieViewModel(withMovie: movie, service: MovieService.shared)
        protocolDelegate?.openMovie(newViewModel)
    }
}

extension MovieListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        if showTags {
            // Use this view to calculate the optimal size based on the collection view's width
            return headerView.systemLayoutSizeFitting(CGSize(width: frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required, // Width is fixed
                verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        }
        
        return .zero
    }
}

extension MovieListCollectionView: HistoryTagViewDelegate {
    func tagPressed(_ tag: String) {
        protocolDelegate?.tagPressed(tag)
    }
    
    func tagRemove(_ tag: String) {
        History.removeTag(tag)
        UIView.animate(withDuration: 0) {[weak self] in
            self?.performBatchUpdates({
                self?.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
        }
    }
}
