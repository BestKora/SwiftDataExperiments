//
//  FilterFlights.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftData

struct FilterFlightsView: View {
    
    @Query(filter: #Predicate<Airport> { $0.flightsTo.count > 0 }, sort: \.name, order: .forward)
               var airportsTO: [Airport]
    @Query(filter: #Predicate<Airport> { $0.flightsFrom.count > 0 }, sort: \.name, order: .forward)
               var airportsFROM: [Airport]
    @Query(sort: \Airline.name, order: .forward) var airlines: [Airline]
    
    @Binding var flightSearch: FlightFilter
    @Binding var isPresented: Bool
    
    @State private var draft: FlightFilter
    @State private var cameraPosion :  MapCameraPosition
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
        
    init(flightSearch: Binding<FlightFilter>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
        _mapRegion = State(initialValue: MKCoordinateRegion(center: flightSearch.wrappedValue.destination?.coordinate ??
                                                            CLLocationCoordinate2D(latitude: 37.6188056, longitude: -122.3754167),
                                                            span:mapSpan))
        _cameraPosion = State(initialValue:
                .region(MKCoordinateRegion(center: flightSearch.wrappedValue.destination?.coordinate ??
                                           CLLocationCoordinate2D(latitude: 37.6188056, longitude: -122.3754167),
                                           latitudinalMeters: flightSearch.wrappedValue.destination == nil ? 700000 : 10000,
                                           longitudinalMeters: flightSearch.wrappedValue.destination == nil ? 700000 : 10000)))
    }
    
   var destination: Binding<Airport?> {
        return Binding<Airport?>(
            get: { return self.draft.destination },
            set: { airport in
                    self.draft.destination = airport
            }
        )
    }
    
    private func updateMapRegion (){
        withAnimation(.easeIn){
            mapRegion = MKCoordinateRegion(
                center:self.draft.destination?.coordinate
                                           ??
                CLLocationCoordinate2D(latitude: 37.6188056, longitude: -122.3754167),
                           span:mapSpan)
        }
        cameraPosion = .region($mapRegion.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
               Section {
                    Picker("Destination", selection: $draft.destination) {
                        Text("Any").tag(Airport?.none)
                        ForEach(airportsTO) { (airport: Airport?) in
                           Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                        }
                    }
                    .onChange(of: draft.destination) { updateMapRegion()}
                   
                   if draft.destination != nil {
                       Map(position: $cameraPosion){
                           Marker(draft.destination?.name ?? "",
                                  systemImage: "airplane",
                                  coordinate: draft.destination?.coordinate ??
                                  CLLocationCoordinate2D(latitude: 37.6188056, longitude: -122.3754167))
                           .tint(.blue)
                       }
                       .frame(minHeight: 280)
                   } else {
                       Map(position: $cameraPosion){
                           ForEach (airportsFROM) { airport in
                               Marker(airport.icao, systemImage: "airplane",coordinate: airport.coordinate)
                                   .tint(.blue)
                           }
                       }
                       .mapControls{
                           MapScaleView()
                       }
                       .frame(minHeight: 360)
                   }
                }
                Section {
                    Picker("Origin", selection: $draft.origin) {
                        Text("Any").tag(Airport?.none)
                        ForEach(airportsFROM) { (airport: Airport?) in
                            Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                        }
                    }
                    Picker("Airline", selection: $draft.airline) {
                        Text("Any").tag(Airline?.none)
                        ForEach(airlines) { (airline: Airline?) in
                            Text("\(airline?.friendlyName ?? "Any")").tag(airline)
                        }
                    }
                    Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {cancel}
                ToolbarItem(placement: .topBarTrailing) {done}
            }
            .navigationTitle("Filter Flights")
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
           isPresented = false
        }
    }
    
    var done: some View {
        Button("Done") {
            flightSearch = draft
            isPresented = false
        }
    }
}

#Preview {
 //   MainActor.assumeIsolated {
        FilterFlightsView(flightSearch: .constant(FlightFilter()), isPresented: .constant(true))
               .modelContainer(previewContainer)
  //     }
}

