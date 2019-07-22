//
//  ArtistCollectionCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 21/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ArtistCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageArtist: UIImageView!
    
    func setImageCollection(imageArtist: Data?) {
        self.imageArtist.layer.cornerRadius = self.imageArtist.frame.height / 2
        self.imageArtist.clipsToBounds = true
        self.imageArtist.image = imageArtist.dataToUIImage
    }
}
