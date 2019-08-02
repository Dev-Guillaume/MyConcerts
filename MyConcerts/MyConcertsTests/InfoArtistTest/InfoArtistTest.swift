//
//  InfoArtistTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 01/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FakeResponseInfoArtist {
    
    static var correctData: Data? {
        let bundle = Bundle(for: FakeResponseInfoArtist.self)
        let url = bundle.url(forResource: "ResultApiInfoArtist", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var nilData: Data? {
        let bundle = Bundle(for: FakeResponseInfoArtist.self)
        let url = bundle.url(forResource: "ResultApiInfoArtistNil", withExtension: "json")!
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

class InfoArtistTest: XCTestCase {
    
    func testGetDataInfoArtistWhenDataIsIncorrectResponseIsIncorrectWithNoErrorThenResultShouldBeKO() {
        let infoArtist = InfoArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoArtist.session = URLSessionFake(data: FakeResponseInfoArtist.incorrectData, response: FakeResponseInfoArtist.responseKO, error: nil)
        infoArtist.searchArtist(artist: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetDataInfoArtistWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let infoArtist = InfoArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoArtist.session = URLSessionFake(data: FakeResponseInfoArtist.correctData, response: FakeResponseInfoArtist.responseOK, error: nil)
        infoArtist.searchArtist(artist: "") { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataInfoArtistWhenDataIsNilResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let infoArtist = InfoArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoArtist.session = URLSessionFake(data: FakeResponseInfoArtist.nilData, response: FakeResponseInfoArtist.responseOK, error: nil)
        infoArtist.searchArtist(artist: "") { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetDataInfoManyArtistsWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let infoArtist = InfoArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoArtist.session = URLSessionFake(data: FakeResponseInfoArtist.correctData, response: FakeResponseInfoArtist.responseOK, error: nil)
        infoArtist.searchManyArtists(arrayArtists: [Name(name: nil)]) { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetDataInfoManyArtistsWhenDataIsNilResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let infoArtist = InfoArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        infoArtist.session = URLSessionFake(data: FakeResponseInfoArtist.correctData, response: FakeResponseInfoArtist.responseOK, error: nil)
        let data: [DataJSON] = [Performance(displayName: "")]
        infoArtist.searchManyArtists(arrayArtists: data) { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetImageArtistWhenUrlIsNilThenResultShouldBeNil() {
        let infoArtist = InfoArtist()
        
        XCTAssertNil(infoArtist.recoverDataImage(urlImage: ""))
    }
}
