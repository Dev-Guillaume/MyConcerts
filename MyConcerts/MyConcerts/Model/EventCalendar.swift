//
//  EventCalendar.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 24/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import EventKit

struct IconFavorite {
    static var boolean: Bool = true
}

class EventCalendar {
    var detailEvent: DetailEvent
    
    init(detailEvent: DetailEvent) {
        self.detailEvent = detailEvent
    }
    
    var structuredLocation: EKStructuredLocation {
        let location = CLLocation(latitude: self.detailEvent.location.lat ?? 0, longitude: self.detailEvent.location.lng ?? 0)
        let structuredLocation = EKStructuredLocation(title: self.detailEvent.displayName ?? "")
        structuredLocation.geoLocation = location
        return structuredLocation
    }
    
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
            event.title = self.detailEvent.displayName
            event.startDate = startDateEvent
            event.endDate = startDateEvent.endDate
            event.structuredLocation = self.structuredLocation
            event.notes = (self.detailEvent.ageRestriction ?? "") + " - " + (self.detailEvent.venue?.phone ?? "")
            event.location = (self.detailEvent.venue?.street ?? "") + " " + (self.detailEvent.location.city ?? "")
            event.url = URL(string: self.detailEvent.uri ?? "No Url for this Event")
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                completionHandler(true)
            } catch {
                NSLog("Error save event")
                completionHandler(false)
            }
        }
    }
}
