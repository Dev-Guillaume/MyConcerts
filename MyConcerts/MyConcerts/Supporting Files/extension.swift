//
//  extension.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 28/06/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let error = Notification.Name("error")
}

extension UIViewController {
    func displayAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func displayError(notification :Notification) {
        guard let dataError = notification.object as? [String] else {
            return
        }
        self.displayAlert(title: dataError[0], message: dataError[1])
    }
}

extension Optional where Wrapped == Data {
    
    var dataToUIImage: UIImage {
        if self != nil, let image = UIImage(data: self!) {
            return image
        }
        return  UIImage(named: "artistNotFound")!
    }
    
}

extension String {
    
    func formateDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EEEE MMM d yyyy"
        return  dateFormatter.string(from: date!)
    }
}

extension Array where Element == Performance {
    var toArrayName: [Name] {
        var arrayName: [Name] = []
        for name in self {
            arrayName.append(Name(name: name.displayName))
        }
        return arrayName
    }
}
