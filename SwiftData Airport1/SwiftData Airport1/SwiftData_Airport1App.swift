//
//  SwiftData_Airport1App.swift
//  SwiftData Airport1
//
//  Created by Tatiana Kornilova on 23.08.2023.
//

import SwiftUI
import SwiftData

@main
struct SwiftData_Airport1App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Airport.self, Airline.self,Flight.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
