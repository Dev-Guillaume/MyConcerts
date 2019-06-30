//
//  Artists.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import UIKit

struct Name: Codable {
    let name: String
}

struct Artist: Codable {
    let artist: [Name]
}

struct ListTopArtists: Codable {
    let artists: Artist
}

class TopArtists: Api {
    
    override func createUrl() {
        self.url = urlApi[.audioscrobbler]! + "&" + keyApi[.audioscrobbler]! + "&format=json"
    }
    
    override func getResponseJSON(data: Data) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData = try JSONDecoder().decode(ListTopArtists.self, from: data)
            NotificationCenter.default.post(name:.dataTopArtists, object: resultData.artists.artist)
        } catch {
            NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
}

struct Info: Codable {
    let strArtist: String
    let strLabel: String?
    let intBornYear: String?
    let intDiedYear: String?
    let strStyle: String?
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
    let image: UIImage
}

class InfoArtist: Api {
    
    private var artist: String = ""
    private var topArtists: [Name] = []
    private var infoArtists: [InfoArtists] = []
    
    func setTopArtists(topArtists: [Name]) {
        self.infoArtists = []
        self.topArtists = topArtists
    }
    
    override func newRequestGet() {
        for nameArtist in self.topArtists {
                self.setArtist(artist: nameArtist.name)
                self.createUrl()  // Call the function createUrl
                guard let url = URL(string: self.url) else {
                    return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
                }
                self.request = URLRequest(url: url) // Create a request
                self.request.httpMethod = "GET" // Set the metthod
                self.getData() // Call the function getData
            }
        self.myGroup.notify(queue: .main) {
            NotificationCenter.default.post(name:.dataInfoArtists, object: self.infoArtists)
        }
    }
    
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    override func createUrl() {
        self.url = urlApi[.audiodb]! + keyApi[.audiodb]! + "/search.php?s=" + self.artist
    }
    
    override func getResponseJSON(data: Data) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData = try JSONDecoder().decode(ListInfoArtist.self, from: data).artists.first!
            self.infoArtists.append(InfoArtists(info: resultData, image: self.recoverImage(urlImage: resultData.strArtistThumb ?? "")))
        } catch {
            NSLog("Error Decoder: \(error)")
        }
    }
    
    private func recoverImage(urlImage: String) -> UIImage { // Download all images of recettes and stock in array
        if URL(string: urlImage) != nil {
            return UIImage(data: try! Data(contentsOf: URL(string: urlImage)!))!
        }
        else {
            return UIImage(named: "artistNotFound")! // Download a default image if the recover failed
        }
    }
}
