//
//  ArtistController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 29/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ArtistController: UIViewController {

    var artist: InfoArtists! // Containing an artist with informations
    var infoEvents: [Events]! // List of all concerts
    var index: Int! // Index cell picked
    var imageArtists: [ImagesArtists]! // List of all perfomers containing Image and name
    var infoEventPicked: DetailEvent! // Detail of the event
    
    let infoConcert = InfoConcert()
    let imageArtist = ImageArtist()
    
    @IBOutlet var artistView: ArtistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistView.setArtistView(infoArtist: artist) // Set the view artist, image artist, name
    }
    
    @IBAction func showDetailArtist(_ sender: Any) {
        performSegue(withIdentifier: "segueToInfoArtist", sender: self)
    }
    
    // Prepare variables for the changement of controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToInfoArtist" {
            let successVC = segue.destination as! InfoArtistController
            successVC.infoArtist = artist // Send info of the artist
        }
        if segue.identifier == "segueToInfoConcert" {
            let successVC = segue.destination as! InfoConcertsController
            successVC.infoEventPicked = self.infoEventPicked // Send info of the concert
            successVC.imageArtists = self.imageArtists // Send list of all perfomers containing Image and name
            successVC.index = self.index // Send index of the cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IconFavorite.iconSearch = true
    }
}

// Display all concerts of the artist
extension ArtistController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoEvents.count
    }
    
    // Return each cell set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConcertsCell = tableView.dequeueReusableCell(withIdentifier: "ConcertCell") as! ConcertsCell
        cell.setConcert(event: infoEvents[indexPath.row])
        return cell
    }
    
    // Return the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    // Check if a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.infoConcert.setIdConcert(idConcert: self.infoEvents[indexPath.row].id) // Set id of the concert
        self.infoConcert.newRequestGet { success, data in // Search information of the concert
            guard success, let data = (data as? [DetailEvent])?.first else {
                return
            }
            self.infoEventPicked = data
            // Search images of perfomerts of the concer
            self.imageArtist.searchManyImagesArtists(arrayArtists: data.performance) { success, data in
                guard success, let data = data else {
                    return
                }
                self.imageArtists = data
                self.index = indexPath.row
                 self.performSegue(withIdentifier: "segueToInfoConcert", sender: self)
            }
        }
    }
}
