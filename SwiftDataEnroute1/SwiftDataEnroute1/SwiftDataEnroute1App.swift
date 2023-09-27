//
//  SwiftDataEnroute1App.swift
//  SwiftDataEnroute1
//
//  Created by Tatiana Kornilova on 13.08.2023.
//

import SwiftUI
import SwiftData

// Use usual filter for flights
@main
struct SwiftDataEnroute1App: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Airport.self, Airline.self, Flight.self])
    }
}
