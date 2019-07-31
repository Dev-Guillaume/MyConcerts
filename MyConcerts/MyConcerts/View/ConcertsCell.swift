//
//  ConcertsCell.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 12/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Set each cells of TableView to display the concerts of an artist
class ConcertsCell: UITableViewCell {

    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setConcert(event: Events) {
        self.displayName.text = event.displayName // Set the name of concert
        self.type.text = event.type // Set the type of concert. Concert or Festival
        self.date.text = event.start.date?.formateDate // Set the date of concert
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
