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

// Get an url containing ID of a concert
class Concert: ApiProtocol, ArtistProtocol {
    var task: URLSessionDataTask?
    var url: String = ""
    var request: URLRequest!
    internal var artist: String = ""
    var ecoMode: Bool = false
    
    // Create an Url to get an Url which will allow to get the ID of a concert
    func createUrl() {
        self.url = self.urlApi[.songkick]! + "search/artists.json?" + self.keyApi[.songkick]! + "&query=" + self.artist
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct EventRef with the methode Decode
            let resultData = try JSONDecoder().decode(EventRef.self, from: data)
            EventsHref(href: resultData.resultsPage.results.artist.first?.identifier.first?.eventsHref ?? "").newRequestGet() { success, data in
                completionHandler(success, data)
                return
            }
        } catch {
            NSLog("Class Concert - Error Decoder: \(error)")
            completionHandler(false, nil)
            return
        }
    }
}
