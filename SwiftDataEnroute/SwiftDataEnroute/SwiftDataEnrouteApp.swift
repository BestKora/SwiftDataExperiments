//
//  SwiftDataEnrouteApp.swift
//  SwiftDataEnroute
//
//  Created by Tatiana Kornilova on 11.08.2023.
//

import SwiftUI
import SwiftData

// Use Query filter for flights
@main
struct SwidtData_AirportApp: App {
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
