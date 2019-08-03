//
//  PatternSingleton.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 01/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct Singleton {
    static let concert = Concert() // Get all concert about an artist
    static let infoConcert = InfoConcert() // Get information about a concert
    static let imageArtist = ImageArtist() // Get image of an artist
    static let infoArtist = InfoArtist() // Get information of an artist
    static let eventHref = EventsHref() // Get information of an concert
}
