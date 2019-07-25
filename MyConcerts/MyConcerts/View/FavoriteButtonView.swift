//
//  FavoriteButtonView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 24/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class FavoriteButtonView: UIBarButtonItem {

    func favoriteSelected() {
        IconFavorite.boolean = true
        self.image = UIImage(named: "FavoriteSelected")
    }
    
    func favoriteUnselected() {
        IconFavorite.boolean = false
        self.image = UIImage(named: "FavoriteUnselected")
    }
    
}
