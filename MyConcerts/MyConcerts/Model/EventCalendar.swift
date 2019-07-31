//
//  EventCalendar.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 24/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import EventKit

class EventCalendar {
    var detailEvent: DetailEvent
    
    init(detailEvent: DetailEvent) {
        self.detailEvent = detailEvent
    }
    
    // Create and return a location for display a view of concert
    var structuredLocation: EKStructuredLocation {
        let location = CLLocation(latitude: self.detailEvent.location.lat ?? 0, longitude: self.detailEvent.location.lng ?? 0)
        let structuredLocation = EKStructuredLocation(title: self.detailEvent.displayName ?? "")
        structuredLocation.geoLocation = location
        return structuredLocation
    }
    
    // Create an Event a save it in personal calendor of user
    func addEventToCalendar(completionHandler: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            guard granted else {
                NSLog("No permission to create an Event")
                completionHandler(false)
                return
            }
            let event = EKEvent(eventStore: eventStore)
            guard let startDateEvent: Date = self.detailEvent.start.datetime?.startDate else {
                completionHandler(false)
                return
            }
            event.title = self.detailEvent.displayName // Set the title of event
            event.startDate = startDateEvent // Set when the event start
            event.endDate = startDateEvent.endDate // Set when the event ends
            event.structuredLocation = self.structuredLocation // Get the location of event
            event.notes = (self.detailEvent.ageRestriction ?? "") + " - " + (self.detailEvent.venue?.phone ?? "") // Set some information like age restriction and phone numer
            event.location = (self.detailEvent.venue?.street ?? "") + " " + (self.detailEvent.location.city ?? "") // Set information of location
            event.url = URL(string: self.detailEvent.uri ?? "No Url for this Event") // Set the url of the event
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent) // Save in the personal calendar of user
                completionHandler(true)
            } catch {
                NSLog("Error save event")
                completionHandler(false)
            }
        }
    }
}
