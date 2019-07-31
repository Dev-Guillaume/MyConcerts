//
//  InfoArtistController.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 12/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class InfoArtistController: UIViewController {

    var infoArtist: InfoArtists! // Containing an artist with informations
    @IBOutlet var infoArtistView: InfoArtistView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoArtistView.setInfoArtist(infoArtist: infoArtist) // Set backround, image artist, name
    }
    
    @IBAction func dismissTextView(_ sender: UITapGestureRecognizer) {
        self.infoArtistView.hiddenTextView()
    }
}

// Display all informations of an artist
extension InfoArtistController: UITableViewDataSource, UITableViewDelegate {
    
    static let website: [Int] = [0, 1, 2] // The index of cells containing an url for safari
    static let biography: Int = 7 // The index of cell containing biography for display in textView
    
    // An array using for display in tableView with info the artist
    var arrayInfoArtist: [(String, UIImage?)] {
        return [(infoArtist.info.strWebsite ?? "No Website", UIImage(named: "website")),
                (infoArtist.info.strFacebook ?? "No Facebook", UIImage(named: "facebook")),
                (infoArtist.info.strTwitter ?? "No Twitter", UIImage(named: "twitter")),
                (infoArtist.info.strLabel ?? "No Label", UIImage(named: "label")),
                (infoArtist.info.intBornYear ?? "?", UIImage(named: "birth")),
                (infoArtist.info.intDiedYear ?? "?", UIImage(named: "died")),
                (infoArtist.info.strGenre ?? "?", UIImage(named: "genre")),
                (infoArtist.info.strBiographyEN ?? "No Biography", UIImage(named: "description")),
                (infoArtist.info.strCountry ?? "?", UIImage(named: "country"))]
    }
    
    // Return the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayInfoArtist.count
    }
    
    // Return each cell set
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoArtistCell = tableView.dequeueReusableCell(withIdentifier: "InfoArtistCell") as! InfoArtistCell
        cell.setInfoArtistCell(data: arrayInfoArtist[indexPath.row] as! (String, UIImage))
        return cell
    }
    
    // Return the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // Check if a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch true {
        case InfoArtistController.website.contains(indexPath.row): // If cell selected is egual to wesite open Safari
            arrayInfoArtist[indexPath.row].0.openSafari
        case InfoArtistController.biography == indexPath.row: // If cell selected is egual to biography open textView
            self.openTextView(biography: arrayInfoArtist[indexPath.row].0)
        default:
            return
        }
    }
    
    func openTextView(biography: String) {
        self.infoArtistView.setTextView(biography: biography)
    }
}
