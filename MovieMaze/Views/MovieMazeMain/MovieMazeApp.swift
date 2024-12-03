//
//  MovieMazeApp.swift
//  MovieMaze
//
//  Created by manjeet kumar on 01/12/24.
//

import SwiftUI

@main
struct MovieMazeApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AllMoviesList()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .navigationViewStyle(.stack)
        }
    }
}
