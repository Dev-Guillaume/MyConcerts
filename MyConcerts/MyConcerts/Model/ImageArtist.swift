//
//  ImageArtist.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct ImagesArtists {
    let name: String
    let image: Data?
}

class ImageArtist: InfoArtist {
    private var imagesArtists: [ImagesArtists] = []
    
    func searchManyImagesArtists(arrayArtists: [DataJSON], completionHandler: @escaping (Bool, [ImagesArtists]?) -> Void) {
        guard let arrayArtists = arrayArtists as? [Performance] else {
            completionHandler(false, nil)
            return
        }
        guard self.cancelTask else {
            completionHandler(false, nil)
            return
        }
        let myGroup: DispatchGroup = DispatchGroup()
        for artist in arrayArtists {
            myGroup.enter()
            self.setArtist(artist: artist.displayName )
            self.newRequestGet { success, data in
                if (success) {
                    self.imagesArtists.append(ImagesArtists(name: artist.displayName, image: self.recoverDataImage(urlImage: (data?.first as? Info)?.strArtistThumb ?? "")))
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            completionHandler(true, self.imagesArtists)
            return
        }
    }
}
