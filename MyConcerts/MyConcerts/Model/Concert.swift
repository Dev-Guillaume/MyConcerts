//
//  Concert.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 18/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

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
    let results: Result
}

struct EventRef: Codable, DataJSON {
    let resultsPage: ResultPage
}

class Concert: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    private var artist: String = ""
    let events = EventsHref()
    
    func createUrl() {
        self.url = self.urlApi[.songkick]! + self.keyApi[.songkick]! + "&query=" + self.artist
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
