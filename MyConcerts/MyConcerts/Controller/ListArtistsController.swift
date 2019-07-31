//
//  ListArtistsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListArtistsController: UIViewController {

    var listTopArtists: [InfoArtists] = [] // Array containing the list of top artists
    let concert = Concert() // Allow to get all concert about an artist
    
    // Variables send to ArtistController
    var artistPicked: InfoArtists! // Containing an artist with informations
    var infoEvents: [Events] = [] // Containing all concerts of an artist
    
    
    @IBOutlet weak var modeEcoView: ModeEcoView!
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        super.viewDidLoad()
        // Set the button ecoMode
        switch modeEco.boolean {
        case true:
            self.modeEcoView.modeEcoOn()
        case false:
            self.modeEcoView.modeEcoOff()
        }
        // Get the topArtist
        TopArtists().newRequestGet { success, data in
            if success {
                // Get the information for each artist recover
                InfoArtist().searchManyArtists(arrayArtists: data!) { success, data in
                    guard success, let data = data else {
                        return
                    }
                    self.modeEcoView.enabledModeEco() // Button ecoMode is enabled
                    self.searchBar.isHidden = false // Display searchBar
                    self.artistsTableView.isHidden = false // Display tabkeView
                    self.activityIndicator.stopActivityIndicator() // Stop activityIndicator
                    self.listTopArtists = data // set data recover
                    self.artistsTableView.reloadData() // Reload tableView
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    // Active or unactive button ecoMode
    @IBAction func buttonModeEco(_ sender: Any) {
        // Create an alertView to warn user
        let alert = UIAlertController(title: "EcoMode", message: "The EcoMode makes it possible to reduce the sending of requests to have a faster application.\nThe informations and photos of each artist are disabled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.ecoMode()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Set boolean to know if the ecoMode is active or inactive in memory
    private func ecoMode() {
        switch modeEco.boolean {
        case true:
            self.modeEcoView.modeEcoOff()
            UserDefaults.standard.set(false, forKey: "ModeEco")
        case false:
            self.modeEcoView.modeEcoOn()
            UserDefaults.standard.set(true, forKey: "ModeEco")
        }
    }
    
    // Prepare variables for the changement of controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArtist" {
            let successVC = segue.destination as! ArtistController
            successVC.artist = self.artistPicked
            successVC.infoEvents = self.infoEvents
        }
    }
}

// Set topArtist or an artist find in tableView
extension ListArtistsController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTopArtists.count
    }
    
    // Return each cell set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtistsCell = tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as! ArtistsCell
        cell.setArtist(name: self.listTopArtists[indexPath.row].info.strArtist, genre: self.listTopArtists[indexPath.row].info.strGenre ?? "", imageArtist: self.listTopArtists[indexPath.row].image)
        return cell
    }
    
    // Return the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    // Check if a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.artistPicked = self.listTopArtists[indexPath.row] // Set the artist pick
        self.concert.setArtist(artist: self.artistPicked.info.strArtist) // Set the artist pick for search all concerts
        self.concert.newRequestGet { success, data in // // Get all concerts about the artist
            guard success, let data = data as? [Events] else {
                return
            }
            self.infoEvents = data // Set all concerts
            self.performSegue(withIdentifier: "segueToArtist", sender: self) // Change controller
        }
    }
}

// Allow to search artist using a searchBar
extension ListArtistsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        InfoArtist().searchArtist(artist: searchBar.text ?? "") { success, data in // Search an artist
            guard success, let data = data else {
                return
            }
            self.artistPicked = data // Set the artist chooses
            self.listTopArtists = [data] // Set the artist using by tableView
            self.artistsTableView.reloadData() // Reload tableView
        }
        searchBar.resignFirstResponder() // Close searchBar
    }
}
