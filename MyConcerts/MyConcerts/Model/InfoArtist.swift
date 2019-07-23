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
    var url: String = ""
    var request: URLRequest!
    internal var artist: String
    private var topArtists: [Name] = []
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
        let myGroup: DispatchGroup = DispatchGroup()
        for artist in arrayArtists {
            myGroup.enter()
            self.setArtist(artist: artist.name ?? "")
            self.newRequestGet { success, data in
                if (success) {
                    self.infoArtists.append(InfoArtists(info: data?.first as! Info,
                                                        image: self.recoverDataImage(urlImage: (data?.first as! Info).strArtistThumb ?? "")))
                }
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            completionHandler(true, self.infoArtists)
        }
    }
    
    func searchArtist(artist: String, completionHandler: @escaping (Bool, InfoArtists?) -> Void) {
        self.infoArtists.removeAll()
        self.setArtist(artist: artist)
        self.newRequestGet { success, data in
            guard success else {
                return completionHandler(false, nil)
            }
            completionHandler(true, InfoArtists(info: (data?.first as? Info)!, image: self.recoverDataImage(urlImage: (data?.first as? Info)?.strArtistThumb ?? "")))
        }
    }
    
    func createUrl() {
        self.url = self.urlApi[.audiodb]! + self.keyApi[.audiodb]! + "/search.php?s=" + self.artist
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData: [DataJSON] = try JSONDecoder().decode(ListInfoArtist.self, from: data).artists
            completionHandler(true, resultData)
        } catch {
            completionHandler(false, nil)
            NSLog("Class InfoArtist - Error Decoder: \(error)")
        }
    }
    
    func recoverDataImage(urlImage: String) -> Data? { // Download all images of recettes and stock in array
        if URL(string: urlImage) != nil {
            return try? Data(contentsOf: URL(string: urlImage)!)
        }
        NSLog("Error Decoder: Can't recover Image")
        return nil
    }
}
