//
//  ApiProtocol.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 18/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

// Enumeration with the different Api
enum ApiName {
    case audioscrobbler, audiodb, songkick
}
protocol DataJSON: Codable {}

protocol ApiProtocol: class {
    var session: URLSession { get }
    var keyApi: [ApiName: String] { get }
    var urlApi: [ApiName: String] { get }
    var url: String { set get }
    var request: URLRequest! { set get }
    
    func createUrl() -> Void
    func newRequestGet(completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
    func getData(completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
}

extension ApiProtocol {
    
    var session: URLSession {
        return URLSession(configuration: .default)
    }
    
    var keyApi: [ApiName: String] {
        return [.audioscrobbler: "api_key=0dc8921cfd471d1ebe01c2f0d5973119",
                .audiodb: "195003",
                .songkick: "apikey=JDyRTYDK3g9GUd3V"]
    }
    
    var urlApi: [ApiName: String] {
        return [.audioscrobbler : "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists",
                .audiodb: "https://theaudiodb.com/api/v1/json/",
                .songkick: "https://api.songkick.com/api/3.0/"]
    }
    
    func newRequestGet(completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        self.createUrl()  // Call the function createUrl
        guard let url = URL(string: self.url) else {
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        self.request = URLRequest(url: url) // Create a request
        self.request.httpMethod = "GET" // Set the metthod
        self.getData() { success, data in
            completionHandler(success, data)
        }
    }
    
    func getData(completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        // Create a task with the Url for get some Date
        let task = self.session.dataTask(with: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { // Get the data
                    completionHandler(false, nil)
                    return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
                }
                // Get the response server. 200 is Ok else is failed
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(false, nil)
                    return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
                }
                self.getResponseJSON(data: data) { success, data in
                    completionHandler(success, data)
                }
            }
        }
        task.resume()
    }
}


protocol ArtistProtocol: class {
    var artist: String { set get }
    func setArtist(artist: String) -> Void
}

extension ArtistProtocol {
    func setArtist(artist: String) {
        self.artist = artist.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}
