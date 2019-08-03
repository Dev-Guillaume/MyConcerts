//
//  ApiProtocolTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 03/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FakeApiProtocolTest: ApiProtocol {
    
    var session: URLSession = URLSession(configuration: .default)
    var url: String = ""
    var request: URLRequest!
    var task: URLSessionDataTask?
    
    func createUrl() {
        self.url = ""
    }
    
    func getResponseJSON(data: Data, completionHandler: @escaping (Bool, [DataJSON]?) -> Void) {
        completionHandler(false, nil)
        return
    }
}

class ApiProtocolTest: XCTestCase {
    
    func testUrlApiProtocolWhenUrlIsIncorrectThenResultShouldBeKO() {
        let fakeApiProtocol = FakeApiProtocolTest()
        
        fakeApiProtocol.newRequestGet { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
        }
    }
}
