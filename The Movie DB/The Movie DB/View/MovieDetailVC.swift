//
//  MovieDetailVC.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
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
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var favButton: UIButton!
        
    var viewModel: MovieDetailViewModel? {
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
            if let path = self?.viewModel?.getFullBackdropPath() {
//                self?.backdropImageView.downloadImage(urlString: path)

                DispatchQueue.main.async {
                    self?.backdropImageView.image = nil
                }
                ImageDownloadService.shared.downloadImage(urlString: path, success: { image in
                    DispatchQueue.main.async {
                        self?.backdropImageView.image = image
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    self?.backdropImageView.image = UIImage(named: "No-Image")
                }
            }
        }
        
        viewModel.posterPath.bind {[weak self] (path) in
            if let path = self?.viewModel?.getFullPosterPath() {
//                self?.posterImageView.downloadImage(urlString: path)

                DispatchQueue.main.async {
                    self?.posterImageView.image = nil
                }
                ImageDownloadService.shared.downloadImage(urlString: path, success: { image in
                    DispatchQueue.main.async {
                        self?.posterImageView.image = image
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(named: "No-Image")
                }
            }
        }
        
        viewModel.title.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.titleLabel.text = text
            }
        }
        
        viewModel.releaseDate.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.releaseDateLabel.text = text
            }
        }
        
        viewModel.genreTitle.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.genreLabel.text = text
            }
            
        }
        
        viewModel.duration.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.durationLabel.text = text
            }
        }
        
        viewModel.tagline.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.taglineLabel.text = text
            }
        }
        
        viewModel.overview.bind {[weak self] (text) in
            DispatchQueue.main.async {
                self?.overviewTextView.text = text
            }
        }
        
        viewModel.isFavorite.bind {[weak self] (isFavorite) in
            DispatchQueue.main.async {
                self?.favButton.isSelected = isFavorite
            }
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
