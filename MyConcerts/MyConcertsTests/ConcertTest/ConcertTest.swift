//
//  ConcertTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 01/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FakeResponseConcert {
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseConcert.self)
        let url = bundle.url(forResource: "ResultApiConcert", withExtension: "json")!
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

class ConcertTest: XCTestCase {
    
    func testGetDataConcertWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let concert = Concert()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        concert.session = URLSessionFake(data: FakeResponseConcert.correctData, response: FakeResponseConcert.responseOK, error: nil)
        concert.setArtist(artist: "")
        concert.newRequestGet { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataConcertWhenDataIsIncorrectResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let concert = Concert()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        concert.session = URLSessionFake(data: FakeResponseConcert.incorrectData, response: FakeResponseConcert.responseOK, error: nil)
        concert.setArtist(artist: "")
        concert.newRequestGet { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
