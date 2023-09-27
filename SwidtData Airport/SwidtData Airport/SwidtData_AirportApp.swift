//
//  SwidtData_AirportApp.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 16.06.2023.
//

import SwiftUI
import SwiftData

@main
struct SwidtData_AirportApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Airport.self, Airline.self, Flight.self])
    }
}
