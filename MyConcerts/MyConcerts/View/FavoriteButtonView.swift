//
//  FavoriteButtonView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 24/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Struct to know if button Favorite is pressed
struct IconFavorite {
    static var iconSearch: Bool = true
    static var iconFavorite: Bool = false
}

class FavoriteButtonView: UIBarButtonItem {
    
    // Initialise the view of button favorite when we change controller
    var initIconFavorite: String = "" {
        didSet {
            switch self.initIconFavorite {
            case "Search":
                switch IconFavorite.iconSearch {
                case true :
                    self.selectIconFavorite = "Search"
                case false :
                    self.unselectIconFavorite = "Search"
                }
            case "Favorite":
                switch IconFavorite.iconFavorite {
                case true :
                    self.selectIconFavorite = "Favorite"
                case false :
                    self.unselectIconFavorite = "Favorite"
                }
            default:
                return
            }
        }
    }
    
    // Display Icon Favorite to select
    var selectIconFavorite: String = "" {
        didSet {
            switch self.selectIconFavorite {
            case "Search":
                IconFavorite.iconSearch = true
            case "Favorite":
                IconFavorite.iconFavorite = true
            default:
                return
            }
            self.image = UIImage(named: "FavoriteSelected")
        }
    }
    
    // Display Icon Favorite to unselect
    var unselectIconFavorite: String = "" {
        didSet {
            switch self.unselectIconFavorite {
            case "Search":
                IconFavorite.iconSearch = false
            case "Favorite":
                IconFavorite.iconFavorite = false
            default:
                return
            }
            self.image = UIImage(named: "FavoriteUnselected")
        }
    }
}
