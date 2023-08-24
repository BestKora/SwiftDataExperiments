//
//  FilterICAOView.swift
//  SwiftDataEnroute
//
//  Created by Tatiana Kornilova on 12.08.2023.
//

import SwiftUI
import SwiftData

struct FilterICAOView: View {
    @Query(filter: #Predicate<Airport> { $0.flightsFrom.count > 0 },
           sort: \Airport.name, order: .forward) var airportsFROM: [Airport]
    @Binding var originICAO: String?
    @Binding var isPresented: Bool
    @State private var airportFrom: Airport?
        
    init(originICAO: Binding<String?>, isPresented: Binding<Bool>, context: ModelContext) {
        _originICAO = originICAO
        _isPresented = isPresented
        guard let icao = originICAO.wrappedValue,icao.count > 0  else {return}
        _airportFrom = State(wrappedValue:Airport.withICAO(icao, context: context))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                    Picker("Origin", selection: $airportFrom) {
                        Text("Any").tag(Airport?.none)
                        ForEach(airportsFROM) { (airport: Airport?) in
                            Text("\(airport?.name/*friendlyName*/ ?? "Any")").tag(airport)
                        }
                    }
                    .pickerStyle(.inline)
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
           originICAO = airportFrom?.icao
           isPresented = false
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        return FilterICAOView( originICAO: .constant("KSFO"), isPresented: .constant(true), context: previewContainer.mainContext)
               .modelContainer(previewContainer)
       }
}
