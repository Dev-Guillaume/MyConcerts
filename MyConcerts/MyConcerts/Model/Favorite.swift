//
//  Favorite.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 26/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import CoreData

public class Favorite: NSManagedObject {
    
    static var favorite: [Favorite] { // Get an Array of favorites
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favorites
    }
    
    // Add an element in momory
    func addElement(detailEvent: DetailEvent, performers: [ImagesArtists]) {
        self.ageRestriction = detailEvent.ageRestriction
        self.capacity = Int64(detailEvent.venue?.capacity ?? -1)
        self.date = detailEvent.start.date
        self.datetime = detailEvent.start.datetime
        self.displayName = detailEvent.displayName
        self.displayVenue = detailEvent.venue?.displayName
        self.lat = detailEvent.location.lat ?? 0
        self.lng = detailEvent.location.lng ?? 0
        self.phone = detailEvent.venue?.phone
        self.popularity = detailEvent.popularity
        self.street = detailEvent.venue?.street
        self.time = detailEvent.start.time
        self.type = detailEvent.type
        self.uri = detailEvent.uri
        for performer in performers {
            self.addToPerformance(addPerformer(performer: performer))
        }
        Favorite.save() // Save the new element
    }
    
    // Add the list performers of concert
    func addPerformer(performer: ImagesArtists) -> PerformanceFavorite {
        let performance = PerformanceFavorite(context: AppDelegate.viewContext)
        performance.displayName = performer.name
        performance.image = performer.image
        return (performance)
    }
    
    // Delete all favorites
    static func resetFavorite() {
        for favorite in Favorite.favorite {
            AppDelegate.viewContext.delete(favorite)
        }
        Favorite.save() // Save the changement
    }
    
    static func deleteElement(row: Int) { // Delete an element with index
        if (row > Favorite.favorite.count) {
            return
        }
        let element = Favorite.favorite[row]
        AppDelegate.viewContext.delete(element)
        Favorite.save()
    }
    
    static private func save() {
        do {
            try  AppDelegate.viewContext.save()
            NotificationCenter.default.post(name: .reloadFavorites, object: nil)
        } catch  {
            NotificationCenter.default.post(name: .error, object: ["Error Saving", "Can't save the data"])
        }
    }
    
    func restoreAllFavorites() -> (DetailEvent, [ImagesArtists]) { // Get all Favorite in a Struct Recipes
        let retorePerformance = self.restorePerformance()
        let detailEvent = DetailEvent(location: Location(city: self.displayVenue, lng: self.lng, lat: self.lat), displayName: self.displayName, type: self.type, uri: self.uri, popularity: self.popularity, start: startConcert(date: self.date, time: self.time, datetime: self.datetime), performance: self.restorePerformance().0, ageRestriction: self.ageRestriction, venue: Venue(phone: self.phone, displayName: self.displayVenue, street: self.street, capacity: Int(self.capacity)))
        return (detailEvent, retorePerformance.1)
    }
    
    func restorePerformance() -> ([Performance], [ImagesArtists]) {
        guard let performers = self.performance?.allObjects as? [PerformanceFavorite] else {
            return ([], [])
        }
        var performance: [Performance] = []
        var imageArtists: [ImagesArtists] = []
        for performer in performers {
            performance.append(Performance(displayName: performer.displayName ?? ""))
            imageArtists.append(ImagesArtists(name: performer.displayName ?? "", image: performer.image))
        }
        return (performance, imageArtists)
    }
}
