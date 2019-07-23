//
//  InfoConcertsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 21/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit
import MapKit

class InfoConcertsController: UIViewController {

    var imageArtists: [ImagesArtists]!
    var infoEventPicked: DetailEvent!
    var artistPicked: InfoArtists!
    var infoEvent: [Events]!
    let concert = Concert()
    
    @IBOutlet var infoConcertView: InfoConcertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoConcertView.setInfoConcertView(infoConcert: infoEventPicked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToArtist" {
            let successVC = segue.destination as! ArtistController
            successVC.artist = self.artistPicked
            successVC.infoEvents = self.infoEvent
        }
    }
}

extension InfoConcertsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionCell", for: indexPath) as! ArtistCollectionCell
        cell.setImageCollection(performers: self.imageArtists[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        InfoArtist().searchArtist(artist: self.imageArtists[indexPath.row].name) { success, data in
            guard success, let data = data else {
                return
            }
            self.artistPicked = data
            self.concert.setArtist(artist: self.imageArtists[indexPath.row].name)
            self.concert.newRequestGet { success, data in
                guard success, let data = data as? [Events] else {
                    return
                }
                self.infoEvent = data
                self.performSegue(withIdentifier: "segueToArtist", sender: self)
            }
        }
    }
}

extension InfoConcertsController: UITableViewDataSource, UITableViewDelegate {

    var arrayInfoEvents: [(String, UIImage?)] {
        return [(infoEventPicked.type ?? "No type concert" , UIImage(named: "typeConcert")),
                (String(infoEventPicked.popularity) + " popularity", UIImage(named: "popularity")),
                (infoEventPicked.start.date?.formateDate ?? "No Date", UIImage(named: "date")),
                (infoEventPicked.start.time ?? "No Time", UIImage(named: "time")),
                (infoEventPicked.ageRestriction ?? "No Restriction", UIImage(named: "restriction")),
                (infoEventPicked.venue?.phone ?? "No Phone", UIImage(named: "phone")),
                (infoEventPicked.venue?.capacity.intToString ?? "No Capacity", UIImage(named: "capacity")),
                ((infoEventPicked.venue?.street ?? "") + " " + (infoEventPicked.location.city ?? "No Location"), UIImage(named: "location")),
                (infoEventPicked.venue?.displayName ?? "No Name", UIImage(named: "concert")),
                (infoEventPicked.venue?.description ?? "No Description", UIImage(named: "description")),
                (infoEventPicked.uri ?? "No Webside" , UIImage(named: "website"))]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInfoEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoConcertCell = tableView.dequeueReusableCell(withIdentifier: "InfoConcertCell") as! InfoConcertCell
        cell.setInfoConcertCell(dataInfo: arrayInfoEvents[indexPath.row].0, imageInfo: arrayInfoEvents[indexPath.row].1)
        return cell
    }
}

