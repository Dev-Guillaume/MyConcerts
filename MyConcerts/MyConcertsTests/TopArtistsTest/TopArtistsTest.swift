//
//  TopArtistsTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 01/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FakeResponseTopArtists {
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseTopArtists.self)
        let url = bundle.url(forResource: "ResultApiTopArtists", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://ws.audioscrobbler.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://ws.audioscrobbler.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class QuoteError: Error {}
    static let error = QuoteError()
}

class TopArtistsTest: XCTestCase {
    
    func testGetDataTopArtistsWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let topArtists = TopArtists()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        topArtists.session = URLSessionFake(data: FakeResponseTopArtists.correctData, response: FakeResponseTopArtists.responseOK, error: nil)
        topArtists.newRequestGet { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDataTopArtistsWhenDataIsIncorrectResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let topArtists = TopArtists()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        topArtists.session = URLSessionFake(data: FakeResponseTopArtists.incorrectData, response: FakeResponseTopArtists.responseOK, error: nil)
        topArtists.newRequestGet { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
