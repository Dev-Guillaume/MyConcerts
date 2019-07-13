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
    
    func setInfoArtist(infoArtist: InfoArtists) {
        self.imageArtistNoBlur.layer.cornerRadius = self.imageArtistNoBlur.frame.height / 2
        self.imageArtistNoBlur.clipsToBounds = true
        self.imageArtistNoBlur.image = infoArtist.image
        self.labelNameArtist.text = infoArtist.info.strArtist
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.imageArtist.bounds
        self.imageArtist.addSubview(blurEffectView)
        self.imageArtist.image = infoArtist.image
    }
}
