//
//  Artists.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

protocol DataJSON: Codable {}

struct Name: DataJSON {
    let name: String
}

struct Artist: Codable {
    let artist: [Name]
}

struct ListTopArtists: Codable {
    let artists: Artist
}

class TopArtists: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    
    func createUrl() {
        self.url = self.urlApi[.audioscrobbler]! + "&" + self.keyApi[.audioscrobbler]! + "&format=json"
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct CurrentWeather with the methode Decode
            let resultData: [DataJSON] = try JSONDecoder().decode(ListTopArtists.self, from: data).artists.artist
            completionHandler(true, resultData)
            return
        } catch {
            completionHandler(false, nil)
            return NotificationCenter.default.post(name: .error,object: ["Error Decoder", "Can't decode data in JSON"])
        }
    }
}

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

class InfoArtist: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    private var artist: String = ""
    private var topArtists: [Name] = []
    private var infoArtists: [InfoArtists] = []
    
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func searchManyArtists(arrayArtists: [DataJSON], completionHandler: @escaping (Bool, [InfoArtists]?) -> Void) {
        guard let arrayArtists = arrayArtists as? [Name] else {
            completionHandler(false, nil)
            return
        }
        let myGroup: DispatchGroup = DispatchGroup()
        for artist in arrayArtists {
            myGroup.enter()
            self.setArtist(artist: artist.name)
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
            NSLog("Error Decoder: \(error)")
        }
    }
    
    private func recoverDataImage(urlImage: String) -> Data? { // Download all images of recettes and stock in array
        if URL(string: urlImage) != nil {
            return try? Data(contentsOf: URL(string: urlImage)!)
        }
        return nil
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
            completionHandler(false, nil)
            NSLog("Error Decoder: \(error)")
            return
        }
    }
}

struct Performance: Codable {
    let displayName: String
}

struct Start: Codable {
    let date: String
}

struct Events: DataJSON {
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

class EventsHref: ApiProtocol {
    var url: String = ""
    var request: URLRequest!
    private var href: String = ""
    
    func setHref(href: String) {
        self.href = href
    }
    
    func createUrl() {
        self.url = self.href + "?apikey=JDyRTYDK3g9GUd3V"
        self.url = self.url.replacingOccurrences(of: "http", with: "https")
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        do {
            // Use the struct CurrentWeather with the methode Decode)
            let resultData: [DataJSON] = try JSONDecoder().decode(InfoEvent.self, from: data).resultsPage.results.event
            completionHandler(true, resultData)
            return
        } catch {
            NSLog("Error Decoder: \(error)")
            completionHandler(false, nil)
            return
        }
    }
    
}
