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
    var artistPicked: InfoArtists!
    
    let concert = Concert()
    
    @IBOutlet weak var modeEcoView: ModeEcoView!
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var launchingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch modeEco.boolean {
        case true:
            self.modeEcoView.modeEcoOn()
        case false:
            self.modeEcoView.modeEcoOff()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        TopArtists().newRequestGet { success, data in
            if success {
                InfoArtist().searchManyArtists(arrayArtists: data!) { success, data in
                    guard success, let data = data else {
                        return
                    }
                    self.modeEcoView.enabledModeEco()
                    self.searchBar.isHidden = false
                    self.artistsTableView.isHidden = false
                    self.launchingActivityIndicator.stopAnimating()
                    self.listTopArtists = data
                    self.artistsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func buttonModeEco(_ sender: Any) {
        let alert = UIAlertController(title: "EcoMode", message: "The EcoMode makes it possible to reduce the sending of requests to have a faster application.\nThe informations and photos of each artist are disabled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.ecoMode()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
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
        self.concert.setArtist(artist: self.artistPicked.info.strArtist)
        self.concert.newRequestGet { success, data in
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
        InfoArtist().searchArtist(artist: searchBar.text ?? "") { success, data in
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
