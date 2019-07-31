//
//  InfoConcertView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 22/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import MapKit

class InfoConcertView: UIView {

    @IBOutlet weak var nameConcert: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // Creata en annotation for mapView
    func setInfoConcertView(infoConcert: DetailEvent) {
        self.nameConcert.text = infoConcert.displayName
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Annotation") // Add an annotation
        let location = CLLocationCoordinate2D(latitude: infoConcert.location.lat ?? 0, longitude: infoConcert.location.lng ?? 0) // Set the location with coordinate
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation() // Create annotation
        annotation.title = infoConcert.displayName // Set title of annotation
        annotation.coordinate = location // Add the location
       self.mapView.addAnnotation(annotation) // Add the annotation in mapView
    }
}
