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

    var imageArtists: [ImagesArtists]! // List of all perfomers containing Image and name
    var infoEventPicked: DetailEvent! // All information about an concert
    var artistPicked: InfoArtists! // Information of the artist
    var infoEvent: [Events]! // List of all concerts of an artist
    let concert = Concert()
    var index: Int! // Index cell picked
    
    @IBOutlet weak var favoriteButtonView: FavoriteButtonView!
    @IBOutlet var infoConcertView: InfoConcertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteButtonView.initIconFavorite = navigationController?.title ?? "" // Set the icon favorite
        // Set the concert view, nameConcert, all perfomers etc
        self.infoConcertView.setInfoConcertView(infoConcert: infoEventPicked)
    }
    
    // Prepare variables for the changement of controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArtist" {
            let successVC = segue.destination as! ArtistController
            successVC.artist = self.artistPicked // Send the information of an artist
            successVC.infoEvents = self.infoEvent // Send all event of an artist
        }
    }
    
    // Check if the are a FavoriteController or SearchController
    @IBAction func favoriteConcert(_ sender: Any) {
        if navigationController?.title == "Favorite" {
           self.controllerFavorite()
        }
        else {
            self.controllerSearch()
        }
    }
    
    private func controllerFavorite() {
        if !IconFavorite.iconFavorite {
            Favorite.deleteElement(row: index)
            self.favoriteButtonView.selectIconFavorite = "Favorite"
            return
        }
        else {
            self.favoriteButtonView.unselectIconFavorite = "Favorite"
            self.saveElement()
        }
    }
    
    // Create an alert view to know if the user want to save the event in calendar personal
    // Save the event in memory
    private func controllerSearch() {
        guard IconFavorite.iconSearch else {
            return
        }
        self.favoriteButtonView.unselectIconFavorite = "Search"
        let alert = UIAlertController(title: "Add Event", message: "Do you want add this event on your personal calendar ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            EventCalendar(detailEvent: self.infoEventPicked).addEventToCalendar { success in
                guard success else {
                    self.displayAlert(title: "Add Event", message: "Fail to adding event")
                    return
                }
                self.displayAlert(title: "Add Event", message: "Event added with success !")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.saveElement()
    }
    
    // Save an Element
    private func saveElement() {
        let favorite = Favorite(context: AppDelegate.viewContext)
        favorite.addElement(detailEvent: infoEventPicked, performers: imageArtists)
    }
    
}

// Display all performers of an concert
extension InfoConcertsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Return the number of cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArtists.count
    }
    
    // Return each cell set
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionCell", for: indexPath) as! ArtistCollectionCell
        cell.setImageCollection(performers: self.imageArtists[indexPath.row])
        return cell
    }
    
    // Check if an artist is selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Search information about an artist
        InfoArtist().searchArtist(artist: self.imageArtists[indexPath.row].name) { success, data in
            guard success, let data = data else {
                return
            }
            self.artistPicked = data
            self.concert.setArtist(artist: self.imageArtists[indexPath.row].name) // Set artist
            self.concert.newRequestGet { success, data in // Search all concert of the artist
                guard success, let data = data as? [Events] else {
                    return
                }
                self.infoEvent = data
                if self.navigationController?.title == "Favorite" {
                    IconFavorite.iconFavorite = true
                }
                self.performSegue(withIdentifier: "segueToArtist", sender: self)
            }
        }
    }
}

// Displays all information about a concert
extension InfoConcertsController: UITableViewDataSource, UITableViewDelegate {

    static let website: Int = 9 // The index of cell containing an url for safari
    
    // An array using for display in tableView with info of the event
    var arrayInfoEvents: [(String, UIImage?)] {
        return [(infoEventPicked.type ?? "No type concert" , UIImage(named: "typeConcert")),
                (String(infoEventPicked.popularity) + " popularity", UIImage(named: "popularity")),
                (infoEventPicked.start.date?.formateDate ?? "No Date", UIImage(named: "date")),
                (infoEventPicked.start.datetime ?? "No Time", UIImage(named: "time")),
                (infoEventPicked.ageRestriction ?? "No Restriction", UIImage(named: "restriction")),
                (infoEventPicked.venue?.phone ?? "No Phone", UIImage(named: "phone")),
                (infoEventPicked.venue?.capacity.intToString ?? "No Capacity", UIImage(named: "capacity")),
                ((infoEventPicked.venue?.street ?? "") + " " + (infoEventPicked.location.city ?? "No Location"), UIImage(named: "location")),
                (infoEventPicked.venue?.displayName ?? "No Name", UIImage(named: "concert")),
                (infoEventPicked.uri ?? "No Webside" , UIImage(named: "website"))]
    }
    
    // Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInfoEvents.count
    }
    
    // Return each cell set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoConcertCell = tableView.dequeueReusableCell(withIdentifier: "InfoConcertCell") as! InfoConcertCell
        cell.setInfoConcertCell(dataInfo: arrayInfoEvents[indexPath.row].0, imageInfo: arrayInfoEvents[indexPath.row].1)
        return cell
    }
    
    // Check if a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == InfoConcertsController.website {
            arrayInfoEvents[indexPath.row].0.openSafari // If cell selected is egual to wesite open Safari
        }
    }
}

