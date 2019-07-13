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
    @IBOutlet var artistView: ArtistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistView.setArtistView(infoArtist: artist)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showDetailArtist(_ sender: Any) {
        performSegue(withIdentifier: "segueToInfoArtist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToInfoArtist" {
            let successVC = segue.destination as! InfoArtistController
            successVC.infoArtist = artist
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
        return 101.0
    }
}
