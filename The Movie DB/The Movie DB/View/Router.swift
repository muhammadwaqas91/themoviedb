//
//  Router.swift
//  The Movie DB
//
//  Created by Muhammad Jabbar on 6/29/20.
//  Copyright © 2020 Muhammad Jabbar. All rights reserved.
//

import Foundation
import UIKit
struct Router {
    static func showMovieDetailVC(from controller: BaseVC, viewModel: MovieViewModel) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.viewModel = viewModel
        controller.navigationController?.show(vc, sender: true)
    }
}
