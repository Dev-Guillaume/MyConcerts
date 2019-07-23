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
    
    func setInfoConcertView(infoConcert: DetailEvent) {
        self.nameConcert.text = infoConcert.displayName
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Annotation")
        let location = CLLocationCoordinate2D(latitude: infoConcert.location.lat ?? 0, longitude: infoConcert.location.lng ?? 0)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = infoConcert.displayName
        annotation.coordinate = CLLocationCoordinate2D(latitude: infoConcert.location.lat ?? 0, longitude: infoConcert.location.lng ?? 0)
       self.mapView.addAnnotation(annotation)
    }
}
