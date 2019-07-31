//
//  FavoriteCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 29/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Set each cells of TableView to display favorites
class FavoriteCell: UITableViewCell {

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var nameConcert: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var restriction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // Set Favorite
    func setFavorite(favorite: Favorite) {
        self.layer.cornerRadius = 10 // Round cell
        self.nameConcert.text = favorite.displayName // Set the name of concert
        self.location.text = "\(favorite.street ?? "") \(favorite.city ?? "")" // Set the location of concert
        self.type.text = favorite.type // Set the type of concert
        self.restriction.text = favorite.ageRestriction // Set the ageRestriction of concert
        self.imageBackground.image = createBackground(performanceFavorite: (favorite.performance?.allObjects as? [PerformanceFavorite])) // Get an image with all artists present merged
    }
    
    // Create an image wieh merging a various image of artist
    func createBackground(performanceFavorite: [PerformanceFavorite]?) -> UIImage {
        guard let performers = performanceFavorite else {
            return UIImage()
        }
        let height = self.bounds.height // Set the height of an image to merge
        let width = self.bounds.width / CGFloat(performers.count) // Set the width of an image to merge
        var x: CGFloat = 0
        let size = CGSize(width:  self.bounds.width, height:  self.bounds.height - 5) // Set the size of an image to merge
        UIGraphicsBeginImageContext(size)
        for performer in performers { // Store all image and set postion to merge
            performer.image.dataToUIImage.draw(in: CGRect(x: x, y: 0, width: width, height: height))
            x += width
        }
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext() // Merde all images
        return newImage
    }
}

