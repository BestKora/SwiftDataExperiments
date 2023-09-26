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
    @Query var flights: [Flight]
    
    @Binding var flightFilter: FlightFilter
    @Binding var sorting: FlightSorting
    @State private var showFilter = false
    
    init(flightFilter: Binding<FlightFilter>, flightSorting: Binding<FlightSorting>) {
        self._flightFilter = flightFilter
        self._sorting = flightSorting
        
        let predicate = self.flightFilter.predicateResult
        if let predicate {
            self._flights = Query(filter: predicate, sort:  [self.sorting.sortDescriptor])
        } else {
            self._flights = Query( filter: predicate,sort: [self.sorting.sortDescriptor])
        }
    }
    
  /*  var filteredAFlights: [Flight] {
        let destinationIcao = flightFilter.destination?.icao
        let originIcao = flightFilter.origin?.icao
        let airlineCode = flightFilter.airline?.code
        
        guard destinationIcao != nil || originIcao != nil || airlineCode != nil || flightFilter.inTheAir else {return  flights}
        let c1 = { (flight: Flight) in
                if originIcao != nil {flight.origin.icao.contains (originIcao!)} else {1 == 1}}
            let c2 = { (flight: Flight) in
                if destinationIcao != nil {flight.destination.icao.contains (destinationIcao!)} else {1 == 1}}
            let c3 = { (flight: Flight) in
                if airlineCode != nil {flight.airline.code.contains (airlineCode!)} else {1 == 1}}
            let c4 = { (flight: Flight) in
                if flightFilter.inTheAir { flight.actualOn == nil && flight.actualOff != nil} else {1 == 1}}
         
            return flights.compactMap { flight in
                 return c1 (flight) && c2 (flight) && c3 (flight) && c4 (flight) ? flight : nil
            }
        }*/
    
    var body: some View {
        NavigationView {
            List {
                ForEach (/*filteredAFlights*/ flights) { flight in FlightView(flight: flight) }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Flights  (\(flights.count))")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {load}
                ToolbarItem(placement: .topBarTrailing) {filter}
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker(selection: $sorting) {
                            ForEach(FlightSorting.allCases) { sorting in
                                Text(sorting.title)
                            }
                        } label: {
                            Text("Sort Flights by")
                        }
                        
                    } label: {
                        Text("Sorting")
                    }
                }
            }
            .sheet(isPresented: $showFilter) {
                FilterFlightsView(flightSearch: self.$flightFilter, isPresented: self.$showFilter)
                    .environment(\.modelContext, self.context)
                    .presentationDetents([.large])
            }
        }
        .task  {
            if flights.count == 0 {
             //       await asyncLoad()  // background actor
               await LoadFlights (context: context).asyncLoadMainActor ()
            }
        }
    }
    
 /*   private func asyncLoad () async {  // actor
            let actor = LoadModelActor(container: context.container)
            await actor.airportTask.finish()
            await actor.airlineTask.finish()
            await actor.flightTaskKSFO.finish()
            await actor.flightTaskKORD.finish()
    }*/
    
    var load: some View {
        Button("Load") {
            Task  {
            //    await asyncLoad() // background actor
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
                Text("**\(flight.origin?.city ?? "")**").foregroundColor(.purple)
                Text(" -> ")
                Text("**\(flight.destination?.city ?? "")**").foregroundColor(.purple)
            }.font(.headline)
            
            HStack{
                Text("**\(flight.airline?.name ?? "")**")
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
                    Text(flight.origin?.city ?? "").font(.system(size: 16, weight: .semibold, design: .rounded))
                    Spacer()
                    Text(flight.ident).font(.callout)
                } else {
                    Text(flight.scheduledOff.formatted(date: .omitted, time: .shortened))
                        .font(.callout)
                    Text(flight.destination?.city ?? "" ).font(.system(size: 16, weight: .semibold, design: .rounded))
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
        return FlightsView(flightFilter: .constant(FlightFilter()), flightSorting: .constant(FlightSorting.distanceUP))
               .modelContainer(previewContainer)
}

extension Task {
    @discardableResult
    func finish() async -> Result<Success, Failure>  {
        await self.result
    }
}
