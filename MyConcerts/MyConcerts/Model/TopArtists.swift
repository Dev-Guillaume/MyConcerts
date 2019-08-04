//
//  TopArtists.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 18/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct Name: DataJSON {
    let name: String?
}

struct Artist: Codable {
    let artist: [Name]
}

struct ListTopArtists: Codable {
    let artists: Artist
}

// Get all top artist of the moment
class TopArtists: ApiProtocol {
    var session: URLSession = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    var url: String = ""
    var request: URLRequest!
    
    // Create an URL to get the top artist of the moment
    func createUrl() {
        self.url = self.urlApi[.audioscrobbler]! + "&" + self.keyApi[.audioscrobbler]! + "&format=json"
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct ListTopArtists with the methode Decode
            let resultData: [DataJSON] = try JSONDecoder().decode(ListTopArtists.self, from: data).artists.artist
            completionHandler(true, resultData)
            return
        } catch {
            completionHandler(false, nil)
            return NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
}
