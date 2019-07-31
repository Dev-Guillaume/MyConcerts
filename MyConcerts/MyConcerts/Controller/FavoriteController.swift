//
//  FavoriteController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController {

    var detailEvent: DetailEvent! // All information about an concert
    var imagesArtists: [ImagesArtists]! // List of all perfomers containing Image and name
    var index = 0 // Index cell picked
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: .reloadFavorites, object: nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IconFavorite.iconFavorite = false
    }
    
    @objc func reloadFavorites() {
        self.tableView.reloadData()
    }
    
    // Prepare variables for the changement of controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToInfoConcert" {
            let successVC = segue.destination as! InfoConcertsController
            successVC.infoEventPicked = self.detailEvent // Send detail of the favorite concert
            successVC.imageArtists = self.imagesArtists // Send list images and names of performers
            successVC.index = self.index // Index cell picked
        }
    }
}

extension FavoriteController: UITableViewDataSource, UITableViewDelegate {
    
    // Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorite.favorite.count
    }
    
    // Return each cell set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteCell
        cell.setFavorite(favorite: Favorite.favorite[indexPath.row])
        return cell
    }
    
    // Return the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    // Check if a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorites = Favorite.favorite[indexPath.row].restoreAllFavorites()
        self.detailEvent = favorites.0
        self.imagesArtists = favorites.1
        self.index = indexPath.row
        self.performSegue(withIdentifier: "segueToInfoConcert", sender: self)
    }
}
