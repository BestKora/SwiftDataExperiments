//
//  LoadModelActor.swift
//  SwiftData Airport2
//
//  Created by Tatiana Kornilova on 23.08.2023.
//

import Foundation
import SwiftData

actor LoadModelActor: ModelActor {
    let executor: any ModelExecutor
   
    lazy var flightTaskKSFO  = Task {await flightsAsyncCodable (FilesJSON.flightsFileKSFO4)}
    lazy var flightTaskKORD  = Task {await flightsAsyncCodable (FilesJSON.flightsFileKORD1)}
    lazy var airportTask     = Task {await airportsAsyncCodable (FilesJSON.airportsFile) }
    lazy var airlineTask     = Task {await airLinesAsyncCodable (FilesJSON.airlinesFile) }
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func flightsAsyncCodable (_ nameJSON: String) async  {
        var flights: FlightsCodable?
        do {
            flights = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if  let flightsFromFA = flights  {
                let flightsFA = (flightsFromFA.arrivals)
                + (flightsFromFA.departures )
                + (flightsFromFA.scheduledArrivals )
                + (flightsFromFA.scheduledDepartures)
                 
                    for flightFA in flightsFA {
                        flightFA.origin = Airport.withICAO(flightFA.icaoOrigin, context: context)
                        flightFA.destination = Airport.withICAO(flightFA.icaoDestination, context: context)
                        flightFA.airline = Airline.withCode(flightFA.codeAirLine, context: context)
                        context.insert(flightFA)
                    }
                context.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airportsAsyncCodable(_ nameJSON: String) async {
        var airports: [Airport]? = []
        do {
            airports = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if let airportsFA = airports {
                    for airport in airportsFA {
                        context.insert(airport)
                    }
                context.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airLinesAsyncCodable (_ nameJSON: String) async {
         var airlines: [Airline]? = []
         do {
             airlines = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
             if let airlinesFA = airlines {
                     for airline in airlinesFA {
                         context.insert(airline)
                     }
                 context.saveContext()
             }
         } catch {
             print (" In file \(nameJSON) \(error)")
         }
     }
}
//-------------------------------------------------------------
struct FilesJSON {
    static var airportsFile = "AIRPORTS"
    static var airlinesFile = "AIRLINES"
  
    static var flightsFileKSFO4 = "SFO4"
    static var flightsFileKORD1 = "ORD1"
}
