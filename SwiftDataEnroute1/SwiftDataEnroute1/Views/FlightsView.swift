//
//  FlightsView.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 07/02/2022.
//

import SwiftUI
import SwiftData

struct FlightsView: View {
   @Environment(\.modelContext) private var context
   @Query( sort: \Flight.routeDistance, order: .forward) var flights: [Flight]

    @State private var showFilter = false
    @State var originICAO: String?
    
    var filteredFlights: [Flight] {
        guard  originICAO != nil, originICAO!.count > 0 else {return  flights}
        return flights.filter {$0.origin.icao.contains(originICAO!)}
        }
 
    var body: some View {
        NavigationView {
            List {
                ForEach (filteredFlights) { flight in FlightView(flight: flight) }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Flights  (\(filteredFlights.count) \(originICAO == nil ? "" : originICAO!))")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {load}
                ToolbarItem(placement: .topBarTrailing) {filter}
            }
            .sheet(isPresented: $showFilter) {
                FilterICAOView(originICAO: $originICAO, isPresented: self.$showFilter, context: context)
                    .presentationDetents([.large])
            }
        }
        .task {
            if flights.count == 0 {
                await LoadFlights (context: context).asyncLoadMainActor ()
            }
        }
    }
    
    var load: some View {
        Button("Load") {
            Task {
                await LoadFlights (context: context).asyncLoadMainActor ()
            }
        }
    }
    
    var filter: some View {
        Button("Filter") {
            self.showFilter = true
        }
    }
}

//------Detail Flight -----
struct FlightView: View {
    var flight: Flight
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(flight.ident)
                Text("**\(flight.origin.city)**").foregroundColor(.purple)
                Text(" -> ")
                Text("**\(flight.destination.city)**").foregroundColor(.purple)
            }.font(.headline)
            
            HStack{
                Text("**\(flight.airline.name)**")
                Spacer()
                Text("**\(flight.aircraftType)**")
                    .foregroundColor(.accentColor)
            }
                Text(flight.distanceAndSpeed).font(.headline)
            
                HStack {
                    Text(flight.depature.formatted(date: .abbreviated, time: .shortened))
                    Text("\(Image(systemName: "arrow.up.right"))")
                        .foregroundColor(flight.actualOff != nil ? .blue: .red)
                }
                HStack {
                    Text(flight.arrival.formatted(date: .abbreviated, time: .shortened))
                    Text("\(Image(systemName: "arrow.down.right"))")
                        .foregroundColor(flight.actualOn != nil ? .blue: .red)
                    Spacer()
                    Text(flight.actualOn != nil ? "": "estimate").foregroundColor(.red)
                }
                
                Text(flight.hoursAndSpeed)
                Text(flight.status)
                Text("\(flight.progressPercent)%").font(.title2)
                ProgressView(value: Float(flight.progressPercent), total: 100.0)
            }
        }
    }


//------Detail Flight Short for Airport-----
struct FlightViewShort: View {
    var flight: Flight
    var airport: Airport
    
    var body: some View {
        VStack( alignment: .leading) {
            HStack(spacing: 10){
                if flight.destination == airport {
                    Text(flight.scheduledOn.formatted(date: .omitted, time: .shortened))
                        .font(.callout)
                    Text(flight.origin.city).font(.system(size: 16, weight: .semibold, design: .rounded))
                    Spacer()
                    Text(flight.ident).font(.callout)
                } else {
                    Text(flight.scheduledOff.formatted(date: .omitted, time: .shortened))
                        .font(.callout)
                    Text(flight.destination.city ).font(.system(size: 16, weight: .semibold, design: .rounded))
                    Spacer()
                    Text(flight.ident).font(.callout)
                }
            }
            HStack{
                if flight.destination == airport {
                    Text(flight.arrival.formatted(date: .omitted, time: .shortened))
                        .font(.callout).foregroundColor(flight.actualOn != nil ? .blue :.red)
                    Spacer()
                    Text(flight.actualOn != nil ? "Прилетел": "**\(flight.statusShort)**").foregroundColor(flight.actualOn != nil ? .blue:.red).font(.footnote)
                } else {
                    Text(flight.depature.formatted(date: .omitted, time: .shortened))
                        .font(.callout).foregroundColor(flight.actualOff != nil ? .blue:.red)
                    Spacer()
                    Text(flight.actualOff != nil ? "Вылетел": "**\(flight.statusShort)**").foregroundColor(flight.actualOff != nil ? .blue: .red).font(.footnote)
                }
               
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        return FlightsView()
               .modelContainer(previewContainer)
       }
}
