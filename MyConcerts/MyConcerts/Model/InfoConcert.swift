//
//  InfoConcert.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct Performance: DataJSON {
    let displayName: String
}

struct Venue: Codable {
    let phone: String?
    let displayName: String?
    let street: String?
    let capacity: Int?
}

struct startConcert: Codable {
    let date: String?
    let time: String?
    let datetime: String?
}

struct Location: Codable {
    let city: String?
    let lng: Double?
    let lat: Double?
}

struct DetailEvent: DataJSON {
    let location: Location
    let displayName: String?
    let type: String?
    let uri: String?
    let popularity: Float
    let start: startConcert
    let performance: [Performance]
    let ageRestriction: String?
    let venue: Venue?
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

// Get all information about a concert
class InfoConcert: ApiProtocol {
    var session: URLSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    var url: String = ""
    var request: URLRequest!
    private var idConcert: Int = 0
    var ecoMode: Bool = false
    
    // Set the If of concert
    func setIdConcert(idConcert: Int) {
        self.idConcert = idConcert
    }
    
    // Create an Url for get all information about a concert
    func createUrl() {
        self.url = self.urlApi[.songkick]! + "events/" + String(self.idConcert) + ".json?" + self.keyApi[.songkick]!
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct DetailConcert with the methode Decode
            let resultData: DataJSON = try JSONDecoder().decode(DetailConcert.self, from: data).resultsPage.results.event
            completionHandler(true, [resultData])
        } catch {
            completionHandler(false, nil)
            NSLog("Class InfoConcert - Error Decoder: \(error)")
        }
    }
}
