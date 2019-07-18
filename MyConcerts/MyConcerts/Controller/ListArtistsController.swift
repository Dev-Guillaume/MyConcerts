//
//  ListArtistsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListArtistsController: UIViewController {

    var listTopArtists: [InfoArtists] = []
    var infoEvents: [Events] = []
    
    let infoArtists = InfoArtist()
    let concert = Concert()
    
    var artistPicked: InfoArtists!
    
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var launchingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getInfoEvents), name: .dataInfoEvents, object: nil)
        TopArtists().newRequestGet { success, data in
            if success {
                self.infoArtists.searchManyArtists(arrayArtists: data!) { success, data in
                    guard success, let data = data else {
                        return
                    }
                    self.searchBar.isHidden = false
                    self.artistsTableView.isHidden = false
                    self.launchingActivityIndicator.stopAnimating()
                    self.listTopArtists = data
                    self.artistsTableView.reloadData()
                }
            }
        }
    }
    
    @objc func getInfoEvents(notification: Notification) {
        guard let notificationInfoEvents = notification.object as? [Events] else {
            return
        }
        self.infoEvents = notificationInfoEvents
        performSegue(withIdentifier: "segueToArtist", sender: self)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare variables for the changement of controller
        if segue.identifier == "segueToArtist" {
            let successVC = segue.destination as! ArtistController
            successVC.artist = self.artistPicked
            successVC.infoEvents = self.infoEvents
        }
    }
}

extension ListArtistsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTopArtists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtistsCell = tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as! ArtistsCell
        cell.setArtist(name: self.listTopArtists[indexPath.row].info.strArtist, genre: self.listTopArtists[indexPath.row].info.strGenre ?? "", imageArtist: self.listTopArtists[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.artistPicked = self.listTopArtists[indexPath.row]
        concert.setArtist(artist: self.artistPicked.info.strArtist)
        concert.newRequestGet { success, data in
            guard success, let data = data as? [Events] else {
                return
            }
            self.infoEvents = data
            self.performSegue(withIdentifier: "segueToArtist", sender: self)
        }
    }
    
    
}

extension ListArtistsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.infoArtists.searchArtist(artist: searchBar.text ?? "") { success, data in
            guard success, let data = data else {
                return
            }
            self.artistPicked = data
            self.listTopArtists = [data]
            self.artistsTableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}
