//
//  HomeView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 27.02.2022.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @State private var flightFilter =  FlightFilter()
    @State private var flightSorting = FlightSorting.distanceUP
   
    
    var body: some View {
        TabView {
            FlightsView(flightFilter: $flightFilter, flightSorting: $flightSorting)
                .tabItem{
                    Label("Flights", systemImage: "airplane")
                    Text("Flights")
                }
            AirportsView()
                .tabItem{
                    Label("Airports", systemImage: "globe")
                    Text("Airports")
                }
                
                
            AirlinesView()
                .tabItem{
                    Label("Airlines", systemImage: "airplane.circle")
                    Text("Airlines")
                }
        }
    }
}

#Preview {
        HomeView()
               .modelContainer(previewContainer)
}
