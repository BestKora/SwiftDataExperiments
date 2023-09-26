//
//  LoadModelActor.swift
//  SwiftData Airport2
//
//  Created by Tatiana Kornilova on 23.08.2023.
//

import Foundation
import SwiftData

actor LoadModelActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor

    lazy var flightTaskKSFO  = Task {await flightsAsync (FilesJSON.flightsFileKSFO4)}
    lazy var flightTaskKORD  = Task {await flightsAsync (FilesJSON.flightsFileKORD1)}
    lazy var airportTask  = Task {await airportsAsync (FilesJSON.airportsFile) }
    lazy var airlineTask  = Task {await airLinesAsync (FilesJSON.airlinesFile) }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
      }
    
    func flightsAsync(_ nameJSON: String) async  {
        var flights: FlightsCodable?
        do {
            flights = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if  let flightsFromFA = flights  {
                let flightsFA = (flightsFromFA.arrivals)
                + (flightsFromFA.departures )
                + (flightsFromFA.scheduledArrivals )
                + (flightsFromFA.scheduledDepartures)
                 
                    for flightFA in flightsFA {
                        flightFA.origin = 
                           Airport.withICAO(flightFA.icaoOrigin, context: modelContext)
                        flightFA.destination =
                           Airport.withICAO(flightFA.icaoDestination, context: modelContext)
                        flightFA.airline =
                           Airline.withCode(flightFA.codeAirLine, context: modelContext)
                        modelContext.insert(flightFA)
                    }
                modelContext.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airportsAsync (_ nameJSON: String) async {
        var airports: [Airport]? = []
        do {
            airports = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if let airportsFA = airports {
                    for airport in airportsFA {
                        modelContext.insert(airport)
                    }
                modelContext.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airLinesAsync (_ nameJSON: String) async {
         var airlines: [Airline]? = []
         do {
             airlines = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
             if let airlinesFA = airlines {
                     for airline in airlinesFA {
                         modelContext.insert(airline)
                     }
                 modelContext.saveContext()
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
