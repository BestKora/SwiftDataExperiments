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
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
          .modelContainer(for: [Airport.self, Airline.self, Flight.self])
    }
}
