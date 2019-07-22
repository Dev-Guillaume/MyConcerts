//
//  ArtistController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 29/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ArtistController: UIViewController {

    var artist: InfoArtists!
    var infoEvents: [Events]!
    var index: Int!
    var imageArtists: [(String, Data?)]!
    
    @IBOutlet var artistView: ArtistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistView.setArtistView(infoArtist: artist)
    }
    
    @IBAction func showDetailArtist(_ sender: Any) {
        performSegue(withIdentifier: "segueToInfoArtist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToInfoArtist" {
            let successVC = segue.destination as! InfoArtistController
            successVC.infoArtist = artist
        }
        if segue.identifier == "segueToInfoConcert" {
            let successVC = segue.destination as! InfoConcertsController
            successVC.infoEvent = self.infoEvents[index]
            successVC.imageArtists = self.imageArtists
        }
    }
}

extension ArtistController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ConcertsCell = tableView.dequeueReusableCell(withIdentifier: "ConcertCell") as! ConcertsCell
        cell.setConcert(event: infoEvents[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.infoEvents[indexPath.row].performance)
        ImageArtist().searchManyImagesArtists(arrayArtists: infoEvents[indexPath.row].performance) { success, data in
            guard success, let data = data else {
                return
            }
            self.imageArtists = data
            self.index = indexPath.row
            self.performSegue(withIdentifier: "segueToInfoConcert", sender: self)
        }
    }
}
