//
//  MovieCell.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 6/29/20.
//  Copyright © 2020 Muhammad Waqas. All rights reserved.
//

import UIKit



class MovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    var viewModel: MovieViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
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
            
            viewModel.isFavorite.bind {[weak self] (isFavorite) in
                self?.favButton.isSelected = isFavorite
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func toggleFavAction(_ sender: UIButton) {
        viewModel?.toggleFavorite()
    }
    
}
