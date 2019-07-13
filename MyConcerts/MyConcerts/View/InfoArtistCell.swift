//
//  InfoArtistCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 13/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoArtistCell: UITableViewCell {

    @IBOutlet weak var labelData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setInfoArtistCell(data: String) {
        self.labelData.text = data
    }
    
}
