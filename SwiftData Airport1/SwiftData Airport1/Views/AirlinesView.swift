//
//  AirlinesView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 25.02.2022.
//

import SwiftUI
import SwiftData

struct AirlinesView: View {
    @Query(sort: \Airline.name, order: .forward) private var airlines: [Airline]
    @State private var searchQuery = ""
    
    var filteredAirlines: [Airline] {
            if searchQuery.isEmpty { return airlines }
            return airlines.compactMap { airline in
                return airline.name.contains( searchQuery ) ? airline : nil
            }
        }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAirlines) { airline in
                    NavigationLink(value: airline){
                        HStack{
                            Text( "**\(airline.code)**").foregroundColor(.pink)
                            Text(airline.name )
                        }
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Search for airline")
            .listStyle(.plain)
            .navigationTitle("Airlines (\(airlines.count))")
            .navigationDestination(for: Airline.self) { airline in
                AirlineDetailView(airline: airline)
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        AirlinesView()
               .modelContainer(previewContainer)
       }
}

