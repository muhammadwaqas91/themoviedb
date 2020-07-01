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
    func showHistoryTags(_ showTags: Bool, _ continueSearch: Bool)
    func searchBarTextDidChange(_ text: String, _ hasText: Bool)
    
}

class MovieSearchBar: UISearchBar {
    
    weak var movieSearchBarDelegate: MovieSearchBarDelegate?
    
    var hasText: Bool {
        if let text = text, !text.isEmpty {
            return true
        }
        return false
    }
    
    var continueSearch: Bool  {
        return hasText
    }
    
    var showTags: Bool {
        return !hasText && isFirstResponder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}

extension MovieSearchBar: UISearchBarDelegate {
    
    // called when text starts editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        movieSearchBarDelegate?.showHistoryTags(showTags, continueSearch)
    }
    
    // called when text ends editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        movieSearchBarDelegate?.showHistoryTags(showTags, continueSearch)
    }

     // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: searchText")
        movieSearchBarDelegate?.searchBarTextDidChange(text ?? "", hasText)
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
