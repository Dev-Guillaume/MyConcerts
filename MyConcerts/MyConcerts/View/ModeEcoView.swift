//
//  ModeEcoView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

class ModeEcoView: UIBarButtonItem {
    
    func modeEcoOn() {
        self.image = UIImage(named: "modeEcoActivate")
    }
    
    func modeEcoOff() {
        self.image = UIImage(named: "modeEcoDeactivate")
    }
    
    func enabledModeEco() {
        self.isEnabled = true
    }
}
