//
//  InfoConcertView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 22/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoConcertView: UIView {

    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var nameConcert: UILabel!
    
    func setInfoConcertView(dataImageArtist: Data?, nameConcert: String) {
        self.imageArtist.layer.cornerRadius = self.imageArtist.frame.height / 2
        self.imageArtist.clipsToBounds = true
        self.imageArtist.image = dataImageArtist.dataToUIImage
        self.nameConcert.text = nameConcert
    }
}
