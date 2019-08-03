//
//  FavoriteTest.swift
//  MyConcertsTests
//
//  Created by Guillaume Djaider Fornari on 03/08/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import XCTest
@testable import MyConcerts

class FavoriteTest: XCTestCase {
    
    var incorrectData: DetailEvent {
        return DetailEvent(location: Location(city: nil, lng: nil, lat: nil), displayName: nil, type: nil, uri: nil, popularity: 0.0, start: startConcert(date: nil, time: nil, datetime: nil), performance: [Performance(displayName: "")], ageRestriction: nil, venue: nil)
    }
    
    var correctData: DetailEvent {
        return DetailEvent(location: Location(city: "Paris", lng: 0, lat: 0), displayName: "ConcertTest", type: "Concert", uri: "concert.com", popularity: 0.0, start: startConcert(date: "2019-08-03", time: "10:00:00", datetime: "2019-08-03T10:00:00-0700"), performance: [Performance(displayName: "")], ageRestriction: "0", venue: Venue(phone: "00000000", displayName: "", street: "", capacity: 1000))
    }
    
    func testRestoreDataWhenFavoriteIsCorrectThenResultShouldBeOK() {
        Favorite.resetFavorite()
        let favorite = Favorite(context: AppDelegate.viewContext)
        
        favorite.addElement(detailEvent: self.correctData, performers: [ImagesArtists(name: "", image: nil)])
        let result = favorite.restoreAllFavorites()
        XCTAssertNotNil(result.0)
        XCTAssertNotNil(result.1)
    }
    
    func testRestoreDataWhenFavoriteIsIncorrectThenResultShouldBeOK() {
        Favorite.resetFavorite()
        let favorite = Favorite(context: AppDelegate.viewContext)
        
        favorite.addElement(detailEvent: self.incorrectData, performers: [ImagesArtists(name: "", image: "".data(using: .utf8))])
        let result = favorite.restoreAllFavorites()
        XCTAssertNotNil(result.0)
        XCTAssertNotNil(result.1)
    }
    
    func testDeleteElementWHenFavoriteIsNotEmptyThenResultShouldBeOK() {
        Favorite.resetFavorite()
        let favorite = Favorite(context: AppDelegate.viewContext)
        
        favorite.addElement(detailEvent: self.correctData, performers: [ImagesArtists(name: "", image: nil)])
        Favorite.deleteElement(row: 0)
        XCTAssertEqual(Favorite.favorite.count, 0)
    }
    
    func testDeleteElementWHenFavoriteIsEmptyThenResultShouldBeIgnored() {
        Favorite.resetFavorite()
        Favorite.deleteElement(row: 0)
        XCTAssertEqual(Favorite.favorite.count, 0)
    }
}
