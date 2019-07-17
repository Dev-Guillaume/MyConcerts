//
//  Api.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

import Foundation

// Enumeration with the different Api
enum ApiName {
    case audioscrobbler, audiodb, songkick
}

// Array with key Api
let keyApi: [ApiName: String] = [.audioscrobbler: "api_key=0dc8921cfd471d1ebe01c2f0d5973119",
                                 .audiodb: "195003",
                                 .songkick: "apikey=JDyRTYDK3g9GUd3V"]
// Array with url Api
let urlApi: [ApiName: String] = [.audioscrobbler : "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists",
                                 .audiodb: "https://theaudiodb.com/api/v1/json/",
                                 .songkick: "https://api.songkick.com/api/3.0/search/artists.json?"]



protocol ApiProtocol: class {
    var session: URLSession { get }
    var myGroup: DispatchGroup { get }
    var keyApi: [ApiName: String] { get }
    var urlApi: [ApiName: String] { get }
    var url: String { set get }
    var request: URLRequest! { set get }
    
    func createUrl() -> Void
    func newRequestGet() -> Void
    func getData() -> Void
    func getResponseJSON(data: Data) -> Void
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
                .songkick: "https://api.songkick.com/api/3.0/search/artists.json?"]
    }
    
    func newRequestGet() {
        self.createUrl()  // Call the function createUrl
        guard let url = URL(string: self.url) else {
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        self.request = URLRequest(url: url) // Create a request
        self.request.httpMethod = "GET" // Set the metthod
        self.getData() // Call the function getData
    }
    
    func getData() {
        // Create a task with the Url for get some Date
        self.myGroup.enter()
        let task = self.session.dataTask(with: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { // Get the data
                    return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
                }
                // Get the response server. 200 is Ok else is failed
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
                }
                self.getResponseJSON(data: data) // Call the function getResponseJSON for get the data converted into JSON
                self.myGroup.leave()
            }
        }
        task.resume()
    }
}

// Class Mother Api
// Containing different mehodes for get some Data using requests
/*class Api: ApiProtocol {
    var myGroup: DispatchGroup = DispatchGroup()
    
    var url: String = ""
    
    var request: URLRequest!
    
    /*var request: URLRequest!
    var url: String!
    var session = URLSession(configuration: .default)
    let myGroup = DispatchGroup()*/
    
    // This function is overrided in the others classes for set a specific url
    func createUrl() {}
    
    // Call some function for create a request and send it
    /*func newRequestGet() {
        self.createUrl()  // Call the function createUrl
        guard let url = URL(string: self.url) else {
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        self.request = URLRequest(url: url) // Create a request
        self.request.httpMethod = "GET" // Set the metthod
        self.getData() // Call the function getData
    }*/
    
    // Get the data received
    /*internal func getData() {
        // Create a task with the Url for get some Date
        self.myGroup.enter()
        let task = self.session.dataTask(with: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { // Get the data
                    return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
                }
                // Get the response server. 200 is Ok else is failed
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
                }
                self.getResponseJSON(data: data) // Call the function getResponseJSON for get the data converted into JSON
                self.myGroup.leave()
            }
        }
        task.resume()
    }*/
    
    // This function is overrided in the others classes for get the data into JSON
    func getResponseJSON(data: Data) {}
}*/
