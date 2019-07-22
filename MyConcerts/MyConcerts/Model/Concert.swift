//
//  Concert.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 18/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct Identifier: Codable {
    let eventsHref: String?
}

struct ArtistBis: Codable {
    let identifier: [Identifier]
}

struct Result: Codable {
    let artist: [ArtistBis]
}

struct ResultPage: Codable {
    let results: Result
}

struct EventRef: DataJSON {
    let resultsPage: ResultPage
}

class Concert: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    private var artist: String = ""
    let events = EventsHref()
    
    func createUrl() {
        self.url = self.urlApi[.songkick]! + "search/artists.json?" + self.keyApi[.songkick]! + "&query=" + self.artist
    }
    
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData = try JSONDecoder().decode(EventRef.self, from: data)
            self.events.setHref(href: resultData.resultsPage.results.artist.first?.identifier.first?.eventsHref ?? "")
            self.events.newRequestGet() { success, data in
                completionHandler(success, data)
            }
        } catch {
            NSLog("Class Concert - Error Decoder: \(error)")
            completionHandler(false, nil)
            return
        }
    }
}

struct Performance: DataJSON {
    let displayName: String
}

/*struct Country: Codable {
    let displayName: String?
}

struct City: Codable {
    let displayName: String
    let uri: String
    let country: Country
}*/

struct Venue: Codable {
    let phone: String?
    let displayName: String?
    let capacity: Int
    let lat: Float
    let lng: Float
}

struct startConcert: Codable {
    let date: String?
    let time: String?
}

struct DetailEvent: DataJSON {
    let displayName: String?
    let type: String?
    let uri: String?
    let popularity: Float
    let start: startConcert
    let performance: [Performance]
    let ageRestriction: String?
}

struct ResultsDetailConcert: Codable {
    let event: DetailEvent
}

struct ResultsPageDetailConcert: Codable {
    let results: ResultsDetailConcert
}

struct DetailConcert: Codable {
    let resultsPage: ResultsPageDetailConcert
}

class InfoConcert: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    private var idConcert: Int
    
    init(idConcert: Int) {
        self.idConcert = idConcert
    }
    
    func createUrl() {
        self.url = self.urlApi[.songkick]! + "events/" + String(self.idConcert) + ".json?" + self.keyApi[.songkick]!
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData: DataJSON = try JSONDecoder().decode(DetailConcert.self, from: data).resultsPage.results.event
            completionHandler(true, [resultData])
        } catch {
            completionHandler(false, nil)
            NSLog("Class InfoConcert - Error Decoder: \(error)")
        }
    }
    
    
}
