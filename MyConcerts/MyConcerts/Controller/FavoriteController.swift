//
//  FavoriteController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController {

    var detailEvent: DetailEvent!
    var imagesArtists: [ImagesArtists]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: .reloadFavorites, object: nil)
        super.viewDidLoad()
    }
    
    @objc func reloadFavorites() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToInfoConcert" {
            let successVC = segue.destination as! InfoConcertsController
            successVC.infoEventPicked = self.detailEvent
            successVC.imageArtists = self.imagesArtists
        }
    }
}

extension FavoriteController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorite.favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoriteCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoriteCell
        cell.setFavorite(favorite: Favorite.favorite[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorites = Favorite.favorite[indexPath.row].restoreAllFavorites()
        self.detailEvent = favorites.0
        self.imagesArtists = favorites.1
        self.performSegue(withIdentifier: "segueToInfoConcert", sender: self)
    }
}
