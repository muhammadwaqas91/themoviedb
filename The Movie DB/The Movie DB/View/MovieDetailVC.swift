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
        
        viewModel.backdropPath.bind {[weak self] (path) in
            if let path = viewModel.getFullBackdropPath() {
                self?.backdropImageView.downloadImage(urlString: path)
            }
        }
        
        viewModel.posterPath.bind {[weak self] (path) in
            if let path = viewModel.getFullPosterPath() {
                self?.posterImageView.downloadImage(urlString: path)
            }
        }
        
        viewModel.title.bind {[weak self] (text) in
            self?.titleLabel.text = text
        }
        
        viewModel.releaseDate.bind {[weak self] (text) in
            self?.releaseDateLabel.text = text
        }
        
        viewModel.genreTitle.bind {[weak self] (text) in
            self?.genreLabel.text = text
        }
        
        viewModel.duration.bind {[weak self] (text) in
            self?.durationLabel.text = text
        }
        
        viewModel.overviewHeading.bind {[weak self] (text) in
            self?.overviewHeadingLabel.text = text
        }
        
        viewModel.overview.bind {[weak self] (text) in
            self?.overviewTextView.text = text
        }
        
        viewModel.isFavorite.bind {[weak self] (isFavorite) in
            self?.favButton.isSelected = isFavorite
        }
        
        viewModel.fetchMovieDetail()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }
    
    @IBAction func toggleFavAction(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }
}
