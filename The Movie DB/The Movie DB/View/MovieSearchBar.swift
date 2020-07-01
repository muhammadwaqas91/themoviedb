//
//  MovieSearchBar.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit

protocol MovieSearchBarDelegate: NSObjectProtocol {
     // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String, hasText: Bool)
}

class MovieSearchBar: UISearchBar {
    
    weak var movieSearchBarDelegate: MovieSearchBarDelegate?
    
    var hasText: Bool {
        if let text = text, !text.isEmpty {
            return true
        }
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}

extension MovieSearchBar: UISearchBarDelegate {
    
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
        movieSearchBarDelegate?.searchBar(searchBar, textDidChange: searchText, hasText: hasText)
        
        
    }
    
     // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }

     // called when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
}
