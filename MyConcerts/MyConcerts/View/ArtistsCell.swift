//
//  ArtistsCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Set each cells of TableView to display the topArtist or a search artist
class ArtistsCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelGenre: UILabel!
    @IBOutlet weak var imageArtist: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArtist(name: String, genre: String, imageArtist: Data?) {
        self.labelName.text = name // Set the name of an artist
        self.labelGenre.text = genre // Set the genre of music of an artist
        self.imageArtist.layer.cornerRadius = self.imageArtist.frame.height / 2 // Create a round image
        self.imageArtist.clipsToBounds = true
        self.isHidden = false
        self.imageArtist.image = imageArtist.dataToUIImage // Set the image of artist
    }
}
