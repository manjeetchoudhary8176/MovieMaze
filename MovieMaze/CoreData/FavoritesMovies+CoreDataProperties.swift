//
//  FavoritesMovies+CoreDataProperties.swift
//  
//
//  Created by manjeet kumar on 02/12/24.
//
//

import Foundation
import CoreData


extension FavoritesMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesMovies> {
        return NSFetchRequest<FavoritesMovies>(entityName: "FavoritesMovies")
    }

    @NSManaged public var movieTitle: String?
    @NSManaged public var movieId: Int64

}
