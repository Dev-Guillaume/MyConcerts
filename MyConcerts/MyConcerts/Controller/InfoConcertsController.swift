//
//  InfoConcertsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 21/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoConcertsController: UIViewController {

    var imageArtists: [ImagesArtists]!
    var infoEventPicked: DetailEvent!
    
    @IBOutlet var infoConcertView: InfoConcertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.infoConcertView.setInfoConcertView(dataImageArtist: self.infoEvent.1, nameConcert: self.infoEvent.0.displayName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        /*if segue.identifier == "segueToArtist" {
            let successVC = segue.destination as! ArtistController
            successVC.artist = artistPicked
            successVC.infoEvents = infoEventPicked
        }*/
    }
}

extension InfoConcertsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionCell", for: indexPath) as! ArtistCollectionCell
        cell.setImageCollection(imageArtist: imageArtists[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*let concert = Concert()
        InfoArtist().searchArtist(artist: self.imageArtists[indexPath.row].0) { success, data in
            guard success, let data = data else {
                return
            }
            self.artistPicked = data
            concert.setArtist(artist: self.imageArtists[indexPath.row].0)
            concert.newRequestGet { success, data in
                guard success, let data = data as? [Events] else {
                    return
                }
                self.infoEventPicked = data
                self.performSegue(withIdentifier: "segueToArtist", sender: self)
            }
        }*/
    }
}

extension InfoConcertsController: UITableViewDataSource, UITableViewDelegate {

    var arrayInfoEvents: [(String, UIImage?)] {
        return [(infoEventPicked.type ?? "" , UIImage(named: "typeConcert")),
                (String(infoEventPicked.popularity) + " popularity", UIImage(named: "popularity")),
                (infoEventPicked.uri ?? "" , UIImage(named: "website")),
                (infoEventPicked.start.date?.formateDate ?? "", UIImage(named: "date")),
                (infoEventPicked.start.time ?? "", UIImage(named: "date"))]
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
