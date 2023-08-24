//
//  AirportsView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 23.02.2022.
//

import SwiftUI
import SwiftData

struct AirportsView: View {
   @FocusState private var searchInFocus: Bool
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
                ForEach(filteredAirports) { airport in
                    NavigationLink(value: airport){
                        HStack{
                            Text( "**\(airport.icao)**").foregroundColor(.purple)
                            Text(airport.friendlyName )
                        }
                    }
                }
            }
            .searchable(text: $searchQuery,  prompt: "Search for airport")
            .listStyle(.plain)
            .navigationTitle("Airports (\(airports.count))")
            .navigationDestination(for: Airport.self) { airport in
                AirportDetailView(airport: airport)
            }
        }
    }
    
    /*var airportsListQuery: Query<Airport,[Airport]> {
        var predicate: Predicate<Airport>?
        if !nameSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            predicate = .init(#Predicate<Airport>{ airport in airport.name.contains(nameSearchText)})
            return Query(filter: predicate, sort: \.name, order: .forward)
        } else {
            predicate = .init(#Predicate<Airport>{ airport  in !airport.name.isEmpty})
            return Query( filter: predicate,sort: \.name, order: .forward)
        }
        
    }*/
}

#Preview {
    MainActor.assumeIsolated {
        AirportsView()
               .modelContainer(previewContainer)
       }
}
/*airports*/
