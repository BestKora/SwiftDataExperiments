//
//  FilterICAOView.swift
//  SwiftDataEnroute
//
//  Created by Tatiana Kornilova on 12.08.2023.
//

import SwiftUI
import SwiftData

struct FilterICAOView: View {
    @Query ( filter: #Predicate<Airport> { $0.flightsFrom.count > 0 }) var airportsFROM: [Airport]
    
    @Binding var originICAO: String?
    @Binding var isPresented: Bool
    
    @State private var draft: Airport?
    
        
    init(originICAO: Binding<String?>, isPresented: Binding<Bool>, context: ModelContext) {
        _originICAO = originICAO
        _isPresented = isPresented
        if let icao = originICAO.wrappedValue {
            let airport = Airport.withICAO(icao, context: context)
               _draft = State(wrappedValue:airport)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                    Picker("Origin", selection: $draft) {
                        Text("Any").tag(Airport?.none)
                        ForEach(airportsFROM/*filteredAirportsFROM*/) { (airport: Airport?) in
                            Text("\(airport?.name ?? "Any")").tag(airport)
                         
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
           self.isPresented = false
        }
    }
    
    var done: some View {
        Button("Done") {

            self.originICAO = self.draft?.icao
            self.isPresented = false
        }
    }
}

#Preview {
        FilterICAOView(originICAO: .constant("KSFO"), isPresented: .constant(true), context: previewContainer.mainContext)
               .modelContainer(previewContainer)
}
