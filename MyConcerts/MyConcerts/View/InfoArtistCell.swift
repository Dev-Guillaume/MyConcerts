//
//  InfoArtistCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 13/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Set each cells of TableView to display informations of an artist
class InfoArtistCell: UITableViewCell {

    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var imageData: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setInfoArtistCell(data: (String, UIImage)) {
        self.labelData.text = data.0 // // Set information about an artist. Exemple biography, age, name etc
        self.imageData.image = data.1 // Set the image corresponding
    }
}
