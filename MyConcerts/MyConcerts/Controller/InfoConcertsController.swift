//
//  InfoConcertsController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 21/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoConcertsController: UIViewController {

    var infoEvent: Events!
    var imageArtists: [(String, Data?)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension InfoConcertsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ArtistCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionCell", for: indexPath) as! ArtistCollectionCell
        return cell
    }
}

extension InfoConcertsController: UITableViewDataSource, UITableViewDelegate {

    var arrayInfoEvents: [(String, UIImage?)] {
        return [(infoEvent.displayName , UIImage(named: "website")),
                (infoEvent.type , UIImage(named: "facebook")),
                (String(infoEvent.popularity), UIImage(named: "twitter")),
                (infoEvent.start.date , UIImage(named: "label"))]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayInfoEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoConcertCell = tableView.dequeueReusableCell(withIdentifier: "InfoConcertCell") as! InfoConcertCell
        return cell
    }
}
