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
    let strArtistThumb: String?
}

struct ListInfoArtist: Codable {
    let artists: [Info]
}

struct InfoArtists {
    let info: Info
    let image: Data?
}

class InfoArtist: ApiProtocol, ArtistProtocol {
    var task: URLSessionDataTask?
    var url: String = ""
    var request: URLRequest!
    var cancel: Bool = false
    internal var artist: String
    private var infoArtists: [InfoArtists] = []
    
    init(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    init() {
        self.artist = ""
    }
    
    func searchManyArtists(arrayArtists: [DataJSON], completionHandler: @escaping (Bool, [InfoArtists]?) -> Void) {
        guard let arrayArtists = arrayArtists as? [Name] else {
            completionHandler(false, nil)
            return
        }
        guard self.cancelTask else { // Check if the task is canceled
            completionHandler(false, nil) // If the task is canceled then return
            return
        }
        let myGroup: DispatchGroup = DispatchGroup() // Create an DispatchGroup to check when all requests are finished
        for artist in arrayArtists { // Get all names of a list of artists
            myGroup.enter()
            self.setArtist(artist: artist.name ?? "") // Set the artist who want search information
            self.newRequestGet { success, data in // Get data containning the information of the artist
                if (success) { // Success == true then save information
                    self.infoArtists.append(InfoArtists(info: (data?.first as? Info ?? Info(strArtist: artist.name ?? "", strLabel: nil, intBornYear: nil, intDiedYear: nil, strGenre: nil, strWebsite: nil, strFacebook: nil, strTwitter: nil, strBiographyEN: nil, strCountry: nil, strArtistThumb: nil)),
                                                        image: self.recoverDataImage(urlImage: (data?.first as! Info).strArtistThumb ?? "")))
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) { // All requests are finished
            completionHandler(true, self.infoArtists) // Return information of all artists
        }
    }
    
    // Same than searchManyArtists but search a single artist
    func searchArtist(artist: String, completionHandler: @escaping (Bool, InfoArtists?) -> Void) {
        guard self.cancelTask else {
            completionHandler(false, nil)
            return
        }
        self.infoArtists.removeAll()
        self.setArtist(artist: artist)
        self.newRequestGet { success, data in
            guard success else {
                return completionHandler(false, nil)
            }
            completionHandler(true, InfoArtists(info: ((data?.first as? Info ?? Info(strArtist: artist, strLabel: nil, intBornYear: nil, intDiedYear: nil, strGenre: nil, strWebsite: nil, strFacebook: nil, strTwitter: nil, strBiographyEN: nil, strCountry: nil, strArtistThumb: nil))), image: self.recoverDataImage(urlImage: (data?.first as? Info)?.strArtistThumb ?? "")))
        }
    }
    
    // Create an Url to get the informations of an artist
    func createUrl() {
        self.url = self.urlApi[.audiodb]! + self.keyApi[.audiodb]! + "/search.php?s=" + self.artist
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct ListInfoArtist with the methode Decode
            let resultData: [DataJSON] = try JSONDecoder().decode(ListInfoArtist.self, from: data).artists
            completionHandler(true, resultData)
        } catch {
            completionHandler(false, nil)
            NSLog("Class InfoArtist - Error Decoder: \(error)")
        }
    }
    
    // Try to get data of an Image
    func recoverDataImage(urlImage: String) -> Data? { // Download all images of recettes and stock in array
        if URL(string: urlImage) != nil {
            return try? Data(contentsOf: URL(string: urlImage)!)
        }
        return nil
    }
}
