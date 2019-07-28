//
//  Favorite.swift
//  MyConcerts
//
//  Created by Guillaume Djaider Fornari on 26/07/2019.
//  Copyright © 2019 Guillaume Djaider Fornari. All rights reserved.
//

import Foundation
import CoreData

public class Favorite: NSManagedObject {
    
    static var favorite: [Favorite] { // Get an Array of favorite
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favorites
    }
    
    static func resetFavorite() {
        for favorite in Favorite.favorite {
            AppDelegate.viewContext.delete(favorite) // Delete all favorites
        }
        Favorite.save() // Save the changement
    }
    
    static func deleteElement(row: Int) { // Delete an element with index
        if (row > Favorite.favorite.count) {
            return
        }
        let element = Favorite.favorite[row]
        AppDelegate.viewContext.delete(element)
        Favorite.save()
    }
    
    static private func save() {
        do {
            try  AppDelegate.viewContext.save()
            //NotificationCenter.default.post(name: .reloadFavoritesListRecipes, object: nil)
        } catch  {
            NotificationCenter.default.post(name: .error, object: ["Error Saving", "Can't save the data"])
        }
    }
}
