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
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: [Airport.self, Airline.self, Flight.self])
    }
}
