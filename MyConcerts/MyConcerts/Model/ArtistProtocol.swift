//
//  ArtistProtocol.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

protocol ArtistProtocol: class {
    var artist: String { set get }
    func setArtist(artist: String) -> Void
}

extension ArtistProtocol {
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}
