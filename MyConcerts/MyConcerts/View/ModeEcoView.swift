//
//  ModeEcoView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ModeEcoView: UIBarButtonItem {
    
    // Set the image ecoMode activate
    func modeEcoOn() {
        self.image = UIImage(named: "modeEcoActivate")
    }
    
    // Set the image ecoMode activate
    func modeEcoOff() {
        self.image = UIImage(named: "modeEcoDeactivate")
    }
    
    // Hid the image ecoMode activate
    func enabledModeEco() {
        self.isEnabled = true
    }
}
