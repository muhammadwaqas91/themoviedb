//
//  HistoryTagView.swift
//  The Movie DB
//
//  Created by Muhammad Waqas on 7/1/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit
import TagListView


protocol HistoryTagViewDelegate: NSObjectProtocol {
     // called when text changes (including clear)
    func tagPressed(_ tag: String)
}

class HistoryTagView: UICollectionReusableView {
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var variantsViewHeightContraint: NSLayoutConstraint!
    
//    var historyTags: [String] = ["Ali", "Abdullah", "Romeo", "Shaolin", "Jaki", "USA", "Day"]
    
    weak var delegate: HistoryTagViewDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.delegate = self
    }
    
    
}

extension HistoryTagView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        delegate?.tagPressed(title)
    }
}
