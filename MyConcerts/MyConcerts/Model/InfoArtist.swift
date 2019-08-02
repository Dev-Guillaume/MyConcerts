//
//  InfoArtist.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 18/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct Info: DataJSON {
    let strArtist: String
    let strLabel: String?
    let intBornYear: String?
    let intDiedYear: String?
    let strGenre: String?
    let strWebsite: String?
    let strFacebook: String?
    let strTwitter: String?
    let strBiographyEN: String?
    let strCountry: String?
    let strArtistThumb: String
}

struct ListInfoArtist: Codable {
    let artists: [Info]
}

struct InfoArtists {
    let info: Info
    let image: Data?
}

// Get all info of the artist or many artists
class InfoArtist: ApiProtocol, ArtistProtocol {
    var session: URLSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    var url: String = ""
    var request: URLRequest!
    var cancel: Bool = false
    internal var artist: String = ""
    private var infoArtists: [InfoArtists] = []
    
    func searchManyArtists(arrayArtists: [DataJSON], completionHandler: @escaping (Bool, [InfoArtists]?) -> Void) {
        self.infoArtists.removeAll()
        guard let arrayArtists = arrayArtists as? [Name] else {
            completionHandler(false, nil)
            return
        }
        if self.cancelTask {
            completionHandler(false, nil)
        }
        let myGroup: DispatchGroup = DispatchGroup() // Create an DispatchGroup to check when all requests are finished
        for artist in arrayArtists { // Get all names of a list of artists
            myGroup.enter()
            self.setArtist(artist: artist.name ?? "") // Set the artist who want search information
            self.newRequestGet { success, data in // Get data containning the information of the artist
                if success {
                    if let data = data?.first as? Info { // Success == true then save information
                        self.infoArtists.append(InfoArtists(info: data, image: self.recoverDataImage(urlImage: data.strArtistThumb)))
                    }
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) { // When all requests are finished
            completionHandler(true, self.infoArtists) // Return information of all artists
        }
    }
    
    // Same than searchManyArtists but search a single artist
    func searchArtist(artist: String, completionHandler: @escaping (Bool, InfoArtists?) -> Void) {
        if self.cancelTask {
            completionHandler(false, nil)
        }
        self.infoArtists.removeAll()
        self.setArtist(artist: artist)
        self.newRequestGet { success, data in
            guard success, let data = data?.first as? Info else {
                return completionHandler(false, nil)
            }
            completionHandler(true, InfoArtists(info: data, image: self.recoverDataImage(urlImage: data.strArtistThumb)))
        }
    }
    
    // Create an Url to get the informations of an artist
    func createUrl() {
        self.url = self.urlApi[.audiodb]! + self.keyApi[.audiodb]! + "/search.php?s=" + self.artist
        //print("TopArtists: \(self.url)")
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct ListInfoArtist with the methode Decode
            let resultData: [DataJSON] = try JSONDecoder().decode(ListInfoArtist.self, from: data).artists
            completionHandler(true, resultData)
        } catch {
            completionHandler(false, nil)
            //NSLog("Class InfoArtist - Error Decoder: \(error)")
        }
    }
    
    // Try to get data of an Image
    func recoverDataImage(urlImage: String) -> Data? {
        if URL(string: urlImage) != nil {
            return try? Data(contentsOf: URL(string: urlImage)!)
        }
        return nil
    }
}
