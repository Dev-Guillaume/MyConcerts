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
    
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func searchManyArtists(arrayArtists: [Name]) {
        for artist in arrayArtists {
            self.setArtist(artist: artist.name)
            self.newRequestGet()
        }
        self.myGroup.notify(queue: .main) {
            NotificationCenter.default.post(name:.dataInfoArtists, object: self.infoArtists)
        }
    }
    
    func searchArtist(artist: String) {
        self.infoArtists.removeAll()
        self.setArtist(artist: artist)
        self.newRequestGet()
        self.myGroup.notify(queue: .main) {
            NotificationCenter.default.post(name:.dataInfoArtists, object: self.infoArtists)
        }
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

struct Identifier: Codable {
    let eventsHref: String
}

struct ArtistBis: Codable {
    let identifier: [Identifier]
}

struct Result: Codable {
    let artist: [ArtistBis]
}

struct ResultPage: Codable {
    //let status: String
    let results: Result
}

struct EventRef: Codable {
    let resultsPage: ResultPage
}

class Event: Api {
    private var artist: String = ""
    let events = EventsHref()
    
    override func createUrl() {
        self.url = urlApi[.songkick]! + keyApi[.songkick]! + "&query=" + self.artist
    }
    
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    override func getResponseJSON(data: Data) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData = try JSONDecoder().decode(EventRef.self, from: data)
            self.events.setHref(href: resultData.resultsPage.results.artist.first?.identifier.first?.eventsHref ?? "")
            self.events.newRequestGet()
            /*self.infoArtists.append(InfoArtists(info: resultData, image: self.recoverImage(urlImage: resultData.strArtistThumb ?? "")))*/
        } catch {
            NSLog("Error Decoder: \(error)")
        }
    }
}

struct Performance: Codable {
    let displayName: String
}

struct Start: Codable {
    let date: String
}

struct Events: Codable {
    let displayName: String
    let type: String
    let popularity: Float
    let start: Start
    let performance: [Performance]
}

struct Results: Codable {
    let event: [Events]
}

struct ResultsPage: Codable {
    let results: Results
}

struct InfoEvent: Codable {
    let resultsPage: ResultsPage
}

class EventsHref: Api {
    
    private var href: String = ""
    
    func setHref(href: String) {
        self.href = href
    }
    
    override func createUrl() {
        self.url = self.href + "?apikey=JDyRTYDK3g9GUd3V"
        self.url = self.url.replacingOccurrences(of: "http", with: "https")
    }
    
    override func getResponseJSON(data: Data) {
        do {
            // Use the struct CurrentWeather with the methode Decode)
           let resultData = try JSONDecoder().decode(InfoEvent.self, from: data)
            NotificationCenter.default.post(name:.dataInfoEvents, object: resultData.resultsPage.results.event)
        } catch {
            NSLog("Error Decoder: \(error)")
        }
    }
    
}
