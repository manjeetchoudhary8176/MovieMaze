//
//  Persistence.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import CoreData
import SwiftUI
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "MovieMaze")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//    
//    func addFavoriteMovie(title: String, movieId: Int) {
//        let favoriteMovie = FavoritesMovies(title: title, movieId: movieId)
//        
//    }
//}

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieMaze")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func addFavoriteMovie(title: String, movieId: Int64) {
        let context = container.viewContext
        
        let favoriteMovie = FavoritesMovies(context: context) // Ensure this matches your Core Data model
        favoriteMovie.movieTitle = title
        favoriteMovie.movieId = Int64(movieId) // Use Int64 if Core Data expects 64-bit integers

        do {
            try context.save()
            print("Movie added successfully!")
        } catch {
            print("Failed to add movie: \(error.localizedDescription)")
        }
    }

    func deleteFavoriteMovie(movieId: Int64) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoritesMovies> = FavoritesMovies.fetchRequest() // Ensure this matches your Core Data model
        fetchRequest.predicate = NSPredicate(format: "movieId == %d", movieId)

        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies {
                context.delete(movie)
            }
            try context.save()
            print("Movie deleted successfully!")
        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }
}

