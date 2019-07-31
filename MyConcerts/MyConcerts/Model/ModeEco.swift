//
//  ModeEco.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 23/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation

// Struct with an Boolean, it is set by recover in UserMemory with the khey "ModeEco"
// It allows to know if the ecoMode is activate
struct modeEco {
    static var boolean: Bool {
        return UserDefaults.standard.bool(forKey: "ModeEco")
    }
}
