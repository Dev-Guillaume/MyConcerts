//
//  InfoConcertTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 02/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest

import XCTest
@testable import MyConcerts

class FakeResponseInfoConcert {
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseInfoConcert.self)
        let url = bundle.url(forResource: "ResultApiInfoConcert", withExtension: "json")!
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

class InfoConcertTest: XCTestCase {

    func testGetDataInfoConcertWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let infoConcert = InfoConcert()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoConcert.session = URLSessionFake(data: FakeResponseInfoConcert.correctData, response: FakeResponseInfoConcert.responseOK, error: nil)
        infoConcert.setIdConcert(idConcert: 0)
        infoConcert.newRequestGet { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataInfoConcertWhenDataIsIncorrectResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let infoConcert = InfoConcert()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoConcert.session = URLSessionFake(data: FakeResponseInfoConcert.incorrectData, response: FakeResponseInfoConcert.responseOK, error: nil)
        infoConcert.setIdConcert(idConcert: 0)
        infoConcert.newRequestGet { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
