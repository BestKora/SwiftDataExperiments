//
//  AirportsView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 23.02.2022.
//

import SwiftUI
import SwiftData

struct AirportsView: View {
 //  @Environment(\.modelContext) private var context
   @Query(sort: \Airport.name, order: .forward)  var airports: [Airport]
   @State private var searchQuery = ""
    
    var filteredAirports: [Airport] {
            if searchQuery.isEmpty { return airports }
            return airports.compactMap { airport in
                return airport.city.contains( searchQuery ) ? airport : nil
            }
        }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(airports/*filteredAirports*/) { airport in
                    NavigationLink(value: airport){
                        HStack{
                            Text( "**\(airport.icao)**").foregroundColor(.purple)
                            Text(airport.friendlyName )
                        }
                    }
                }
            }
          //  .searchable(text: $searchQuery, prompt: "Search for airport")
            .listStyle(.plain)
            .navigationTitle("Airports (\(airports.count))")
            .navigationDestination(for: Airport.self) { airport in
                AirportDetailView(airport: airport)
            }
        }
    }
}

#Preview {
 //   MainActor.assumeIsolated {
        AirportsView()
               .modelContainer(previewContainer)
  //     }
}
