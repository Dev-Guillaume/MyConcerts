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

// Using this protocol to have a generic type between some struct
protocol DataJSON: Codable {}

// Protocol Api containing the declaration of variables and functions
protocol ApiProtocol: class {
    var session: URLSession { get } // To create request
    var keyApi: [ApiName: String] { get } // Get the keyApi
    var urlApi: [ApiName: String] { get } // Get the urlApi
    var url: String { set get } // Set and get the requestUrl
    var request: URLRequest! { set get } // To set request
    var ecoMode: Bool { get } // True EcoMode activate / False desactivate then some requests are canceled
    var task: URLSessionDataTask? { get set } // To send request
    var cancel: Bool { get } // Boolean to know if we can canceled the task in model
    var cancelTask: Bool { get } // Return a boolean to know if the task was canceled
    
    func createUrl() -> Void
    func newRequestGet(completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
    func getData(completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void)
}

// ApiProtocol Extension's to declare
extension ApiProtocol {
    
    var ecoMode: Bool {
        return modeEco.boolean
    }
    
    var cancel: Bool {
        return true
    }
    
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
    
    var cancelTask: Bool {
        self.task?.cancel()
        return self.task?.state != URLSessionTask.State.canceling
    }
    
    func newRequestGet(completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        if self.ecoMode == true { // If ecoMode is true, the request can be canceled
            completionHandler(true, [])
            return
        }
        self.createUrl()  // Call the function createUrl to create an url
        guard let url = URL(string: self.url) else { // Check the url
            return NotificationCenter.default.post(name: .error, object: ["Error Url", "Can't construct URL"])
        }
        self.request = URLRequest(url: url) // Create a request
        self.request.httpMethod = "GET" // Set the method
        self.getData() { success, data in
            completionHandler(success, data)
        }
    }
    
    func getData(completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        if (self.cancel == true) { // If cancel is true, we can try to cancel the task is a task is in progress
            guard self.cancelTask else { // Check if the task has been canceled
                completionHandler(false, nil)
                return
            }
        }
        self.task = self.session.dataTask(with: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { // Get the data and check if there are not error
                    completionHandler(false, nil)
                    return NotificationCenter.default.post(name: .error, object: ["Error Data", "Can't recover Data from Api"])
                }
                // Get the response server. 200 is Ok else is failed
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(false, nil)
                    return NotificationCenter.default.post(name: .error, object: ["Error Response", "Error Access from Api"])
                }
                self.getResponseJSON(data: data) { success, data in //Decode the response
                    completionHandler(success, data)
                }
            }
        }
        self.task?.resume()
    }
}
