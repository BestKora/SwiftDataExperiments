//
//  AirportDetailView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 26.02.2022.
//

import SwiftUI
import MapKit
import SwiftData

struct AirportDetailView: View {
    @Environment(\.modelContext) var context
    @Bindable var airport: Airport
    @State private var to: Int = 0
    
    var body: some View {
        VStack{
            AirportMap(airport: $airport)
            Picker("", selection: $to){
                Image(systemName: "airplane.arrival").tag(0)
                Image(systemName: "airplane.departure").tag(1)
            }
            .pickerStyle(.segmented)
            if to == 0 {
                List {
                    ForEach(Array(airport.flightsTo).sorted{$0.arrival < $1.arrival}) { flight in
                        FlightViewShort(flight: flight, airport: airport)
                    }
                }
            } else {
                List {
                    ForEach(Array(airport.flightsFrom).sorted{$0.depature < $1.depature}) { flight in
                        FlightViewShort(flight: flight, airport:airport)
                    }
                }
            }
        }
        .navigationTitle(airport.name)
    }
}

#Preview {
    MainActor.assumeIsolated {
        AirportDetailView(airport: previewAirport)
               .modelContainer(previewContainer)
       }
}
