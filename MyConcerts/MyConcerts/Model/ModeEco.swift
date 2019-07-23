//
//  ModeEco.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

struct modeEco {
    static var boolean: Bool {
        return UserDefaults.standard.bool(forKey: "ModeEco")
    }
}
