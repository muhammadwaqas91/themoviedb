//
//  MovieDetailVC.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewHeadingLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var favButton: UIButton!
    
    var isViewModelAdded: Bool?
    
    var viewModel: MovieViewModel? {
        didSet {
            fillUI()
        }
    }
    
    fileprivate func fillUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        if isViewModelAdded ?? false {
            return
        }
        isViewModelAdded = true
        
        viewModel.backdropPath.addAndNotify(observer: self) {[weak self] (path) in
            if let path = viewModel.getFullBackdropPath() {
                self?.backdropImageView.downloadImage(urlString: path)
            }
        }
        
        viewModel.posterPath.addAndNotify(observer: self) {[weak self] (path) in
            if let path = viewModel.getFullPosterPath() {
                self?.posterImageView.downloadImage(urlString: path)
            }
        }
        
        viewModel.title.addAndNotify(observer: self) {[weak self] (text) in
            self?.titleLabel.text = text
        }
        
        viewModel.releaseDate.addAndNotify(observer: self) {[weak self] (text) in
            self?.releaseDateLabel.text = text
        }
        
        viewModel.genreTitle.addAndNotify(observer: self) {[weak self] (text) in
            self?.genreLabel.text = text
        }
        
        viewModel.duration.addAndNotify(observer: self) {[weak self] (text) in
            self?.durationLabel.text = text
        }
        
        viewModel.overviewHeading.addAndNotify(observer: self) {[weak self] (text) in
            self?.overviewHeadingLabel.text = text
        }
        
        viewModel.overview.addAndNotify(observer: self) {[weak self] (text) in
            self?.overviewTextView.text = text
        }
        
        viewModel.isFavorite.addAndNotify(observer: self) {[weak self] (isFavorite) in
            self?.favButton.isSelected = isFavorite
        }
        
        viewModel.fetchMovieDetail()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillUI()
    }
    
    @IBAction func toggleFavAction(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }
}
