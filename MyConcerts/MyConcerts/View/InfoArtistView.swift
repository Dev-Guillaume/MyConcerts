//
//  InfoArtistView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 12/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoArtistView: UIView {

    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var imageArtistNoBlur: UIImageView!
    @IBOutlet weak var labelNameArtist: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    
    func setInfoArtist(infoArtist: InfoArtists) {
        self.biographyTextView.layer.cornerRadius = 5
        self.biographyTextView.layer.masksToBounds = true
        self.imageArtistNoBlur.layer.cornerRadius = self.imageArtistNoBlur.frame.height / 2
        self.imageArtistNoBlur.clipsToBounds = true
        self.labelNameArtist.text = infoArtist.info.strArtist
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.imageArtist.bounds
        self.imageArtist.addSubview(blurEffectView)
        self.imageArtist.image = infoArtist.image.dataToUIImage
        self.imageArtistNoBlur.image = infoArtist.image.dataToUIImage
    }
    
    func hiddenTextView() {
        self.biographyTextView.isHidden = true
    }
    
    func setTextView(biography: String) {
        self.biographyTextView.isHidden = false
        self.biographyTextView.text = biography
    }
}
