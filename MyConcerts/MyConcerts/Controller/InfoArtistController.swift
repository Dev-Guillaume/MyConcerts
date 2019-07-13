//
//  InfoArtistController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 12/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoArtistController: UIViewController {

    var infoArtist: InfoArtists!
    @IBOutlet var infoArtistView: InfoArtistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoArtistView.setArtist(infoArtist: infoArtist)
    }
}

extension InfoArtistController: UITableViewDataSource, UITableViewDelegate {
    
    var arrayInfoArtist: [String] {
        return [infoArtist.info.strWebsite ?? "No Website", infoArtist.info.strFacebook ?? "No Facebook", infoArtist.info.strTwitter ?? "No Twitter", infoArtist.info.strLabel ?? "No Label", infoArtist.info.intBornYear ?? "?", infoArtist.info.intDiedYear ?? "?", infoArtist.info.strGenre ?? "?", infoArtist.info.strBiographyEN ?? "No Biography", infoArtist.info.strCountry ?? "?"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayInfoArtist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoArtistCell = tableView.dequeueReusableCell(withIdentifier: "InfoArtistCell") as! InfoArtistCell
        cell.setInfoArtistCell(data: arrayInfoArtist[indexPath.row])
        return cell
    }
}
