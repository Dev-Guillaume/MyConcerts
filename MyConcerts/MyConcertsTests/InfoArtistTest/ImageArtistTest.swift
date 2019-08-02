//
//  ImageArtistTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 02/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class ImageArtistTest: XCTestCase {
    
    func testGetDataImageArtistWhenDataIsCorrectResponseIsCorrectWithNoErrorThenResultShouldBeOK() {
        let imageArtist = ImageArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let data: [DataJSON] = [Performance(displayName: "")]
        
        imageArtist.session = URLSessionFake(data: FakeResponseInfoArtist.correctData, response: FakeResponseInfoArtist.responseOK, error: nil)
        //imageArtist.setIdConcert(idConcert: 0)
        imageArtist.searchManyImagesArtists(arrayArtists: data) { success, data in
            XCTAssertTrue(success)
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataImageArtistWhenDataIsNilResponseIsCorrectWithNoErrorThenResultShouldBeKO() {
        let imageArtist = ImageArtist()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let data: [DataJSON] = [Name(name: "")]
        
        imageArtist.session = URLSessionFake(data: FakeResponseInfoArtist.nilData, response: FakeResponseInfoArtist.responseOK, error: nil)
        imageArtist.searchManyImagesArtists(arrayArtists: data) { success, data in
            XCTAssertFalse(success)
            XCTAssertNil(data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
