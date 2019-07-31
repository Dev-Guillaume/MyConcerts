//
//  ActivityIndicatorView.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 26/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import UIKit

// Stop the animation of ActivityIndicator
class ActivityIndicatorView: UIActivityIndicatorView {
    func stopActivityIndicator() {
        self.stopAnimating()
    }
}
