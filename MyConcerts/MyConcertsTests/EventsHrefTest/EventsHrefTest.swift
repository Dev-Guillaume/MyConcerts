//
//  EventsHrefTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 02/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FakeResponseEventsHref {
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseEventsHref.self)
        let url = bundle.url(forResource: "ResultApiEventsHref", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://api.songkick.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://api.songkick.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class QuoteError: Error {}
    static let error = QuoteError()
}

class EventsHrefTest: XCTestCase {
    
    func testGetDataEventsHrefWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let event = EventsHref()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        event.session = URLSessionFake(data: FakeResponseEventsHref.correctData, response: FakeResponseEventsHref.responseOK, error: nil)
        event.setHref(href: "")
        event.newRequestGet { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataEventsHrefWhenDataIsIncorrectResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let event = EventsHref()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        event.session = URLSessionFake(data: FakeResponseEventsHref.incorrectData, response: FakeResponseEventsHref.responseOK, error: nil)
        event.setHref(href: "")
        event.newRequestGet { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
