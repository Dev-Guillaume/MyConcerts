//
//  FavoriteCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 29/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

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

    func setFavorite(favorite: Favorite) {
        self.layer.cornerRadius = 10
        self.nameConcert.text = favorite.displayName
        self.location.text = "\(favorite.street ?? "") \(favorite.city ?? "")"
        self.type.text = favorite.type
        self.restriction.text = favorite.ageRestriction
        self.imageBackground.image = createBackground(performanceFavorite: (favorite.performance?.allObjects as? [PerformanceFavorite]))
    }
    
    func createBackground(performanceFavorite: [PerformanceFavorite]?) -> UIImage {
        guard let performers = performanceFavorite else {
            return UIImage()
        }
        let height = self.bounds.height - 5
        let width = self.bounds.width / CGFloat(performers.count)
        var x: CGFloat = 0
        let size = CGSize(width:  self.bounds.width, height:  self.bounds.height - 5)
        UIGraphicsBeginImageContext(size)
        for performer in performers {
            performer.image.dataToUIImage.draw(in: CGRect(x: x, y: 0, width: width, height: height))
            x += width
        }
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

