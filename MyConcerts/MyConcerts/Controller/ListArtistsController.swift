//
//  ListArtistsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ListArtistsController: UIViewController {

    let artist = TopArtists()
    var listTopArtists: [InfoArtists] = []
    let infoArtists = InfoArtist()
    @IBOutlet weak var artistsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(displayError), name: .error, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setInfoArtists), name: .dataTopArtists, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getListTopArtists), name: .dataInfoArtists, object: nil)
        artist.newRequestGet()
    }
    
    @objc func setInfoArtists(notification: Notification) {
        guard let notificationTopArtists = notification.object as? [Name] else {
            return
        }
        self.infoArtists.setTopArtists(topArtists: notificationTopArtists)
        self.infoArtists.newRequestGet()
    }
    
    @objc func getListTopArtists(notification: Notification) {
        guard let notificationTopArtists = notification.object as? [InfoArtists] else {
            return
        }
        self.listTopArtists = notificationTopArtists
        artistsTableView.reloadData()
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
}

extension ListArtistsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.infoArtists.setTopArtists(topArtists: [Name(name: searchBar.text ?? "")])
        self.infoArtists.newRequestGet()
        searchBar.resignFirstResponder()
    }
}
