//
//  ArtistView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 29/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Display information about an artist when he is selected in tableView
class ArtistView: UIView {

    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var nameArtist: UILabel!

    func setArtistView(infoArtist: InfoArtists) {
        self.imageArtist.layer.cornerRadius = self.imageArtist.frame.height / 2 // Create a round image
        self.imageArtist.clipsToBounds = true
        self.nameArtist.text = infoArtist.info.strArtist // Set name of artist
        self.imageArtist.image = infoArtist.image.dataToUIImage // Set image of an artist
    }

}
