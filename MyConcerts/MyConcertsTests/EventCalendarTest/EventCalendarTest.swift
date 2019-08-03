//
//  EventCalendarTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 03/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class EventCalendarTest: XCTestCase {

    func testEventCalendarWhenDataIsCorrectThenResultShouldBeOK() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let detailEvent = DetailEvent(location: Location(city: "Paris", lng: 0, lat: 0), displayName: "ConcertTest", type: "Concert", uri: "concert.com", popularity: 0.0, start: startConcert(date: "2019-08-03", time: "10:00:00", datetime: "2019-08-03T10:00:00-0700"), performance: [Performance(displayName: "")], ageRestriction: "0", venue: Venue(phone: "00000000", displayName: "", street: "", capacity: 1000))
        
        EventCalendar(detailEvent: detailEvent).addEventToCalendar { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testEventCalendarWhenDataIsIncorrectThenResultShouldBeKO() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let detailEvent = DetailEvent(location: Location(city: nil, lng: nil, lat: nil), displayName: nil, type: nil, uri: nil, popularity: 0.0, start: startConcert(date: nil, time: nil, datetime: nil), performance: [Performance(displayName: "")], ageRestriction: nil, venue: nil)
        
        EventCalendar(detailEvent: detailEvent).addEventToCalendar { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testEventCalendarWhenJustStartEventIsCorrectThenResultShouldBeOk() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        let detailEvent = DetailEvent(location: Location(city: nil, lng: nil, lat: nil), displayName: nil, type: nil, uri: nil, popularity: 0.0, start: startConcert(date: "2019-08-03", time: "10:00:00", datetime: "2019-08-03T10:00:00-0700"), performance: [Performance(displayName: "")], ageRestriction: nil, venue: nil)
        
        EventCalendar(detailEvent: detailEvent).addEventToCalendar { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
