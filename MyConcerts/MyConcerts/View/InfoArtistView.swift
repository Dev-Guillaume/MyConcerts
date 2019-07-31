//
//  InfoArtistView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 12/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Display the detail of an artist
class InfoArtistView: UIView {

    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var imageArtistNoBlur: UIImageView!
    @IBOutlet weak var labelNameArtist: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    
    func setInfoArtist(infoArtist: InfoArtists) {
        self.biographyTextView.layer.cornerRadius = 10
        self.biographyTextView.layer.masksToBounds = true //Set the biography of an artist
        self.imageArtistNoBlur.layer.cornerRadius = self.imageArtistNoBlur.frame.height / 2 // Create a round image
        self.imageArtistNoBlur.clipsToBounds = true
        self.labelNameArtist.text = infoArtist.info.strArtist // Set the name of an artist
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect) // Create a blurEffect
        blurEffectView.frame = self.imageArtist.bounds
        self.imageArtist.addSubview(blurEffectView)
        self.imageArtist.image = infoArtist.image.dataToUIImage // Set the image of an artist
        self.imageArtistNoBlur.image = infoArtist.image.dataToUIImage // Set the image of an artist on background with blur
    }
    
    func hiddenTextView() { // Hidden textView containing biography of an artist
        self.biographyTextView.isHidden = true
    }
    
    func setTextView(biography: String) { // Set and display biography of an artist in textView
        self.biographyTextView.isHidden = false
        self.biographyTextView.text = biography
    }
}
