//
//  FlightFromViewModel.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 27/01/2022.
//

import Foundation
import SwiftData

actor LoadModelActor: ModelActor {
    let executor: any ModelExecutor
    lazy var flightTaskKSFO  = Task {await flightsAsync (FilesJSON.flightsFileKSFO4)}
    lazy var flightTaskKORD  = Task {await flightsAsync (FilesJSON.flightsFileKORD1)}
    lazy var airportTask  = Task {await airportsAsync (FilesJSON.airportsFile) }
    lazy var airlineTask  = Task {await airLinesAsync (FilesJSON.airlinesFile) }
    
    init(container: ModelContainer) {
        let context = ModelContext(container)
        executor = DefaultModelExecutor(context: context)
    }
    
    func flightsAsync(_ nameJSON: String) async  {
        var flights: FlightsInfo?
        do {
            flights = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if  let flightsFromFA = flights  {
                let flightsFA = (flightsFromFA.arrivals)
                + (flightsFromFA.departures )
                + (flightsFromFA.scheduledArrivals )
                + (flightsFromFA.scheduledDepartures)
                 
                    for flightFA in flightsFA {
                        Flight.update(from: flightFA, in: context)
                    }
                context.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airportsAsync(_ nameJSON: String) async {
        var airports: [AirportInfo]? = []
        do {
            airports = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if let airportsFA = airports {
                    for airport in airportsFA {
                        Airport.update(from: airport, context: context)
                    }
                context.saveContext()
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    
    func airLinesAsync(_ nameJSON: String) async {
         var airlines: [AirlineInfo]? = []
         do {
             airlines = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
             if let airlinesFA = airlines {
                     for airline in airlinesFA {
                         Airline.update(info: airline, context: context)
                     }
                 context.saveContext()
             }
         } catch {
             print (" In file \(nameJSON) \(error)")
         }
     }
}

struct FilesJSON {
    static var airportsFile = "AIRPORTS"
    static var airlinesFile = "AIRLINES"
  
    static var flightsFileKSFO4 = "SFO4"
    static var flightsFileKORD1 = "ORD1"
}

struct LoadFlights {
    var context : ModelContext
    var flightsFromFA = FlightsInfo (
                            arrivals: [], departures: [],
                            scheduledArrivals: [], scheduledDepartures: [])
    init(context: ModelContext){
        self.context = context
    }
    //-------------------------------------------------------------- ASYNC AIRLINE
    func airLinesAsync (_ nameJSON: String) async {
         var airlines: [AirlineInfo]? = []
         do {
             airlines = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
             if let airlinesFA = airlines {
                 await MainActor.run {
                     for airline in airlinesFA {
                         Airline.update(info: airline, context: context)
                     }
                 }
             }
         } catch {
             print (" In file \(nameJSON) \(error)")
         }
     }
    //-------------------------------------------------------------- ASYNC AIRPORT
    func airportsAsync(_ nameJSON: String) async {
        var airports: [AirportInfo]? = []
        do {
            airports = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if let airportsFA = airports {
                await MainActor.run {
                    for airport in airportsFA {
                        Airport.update(from: airport, context: context)
                    }
                }
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    //-------------------------------------------------------------- ASYNC FLIGHT
    func flightsAsync(_ nameJSON: String) async  {
        var flights: FlightsInfo?
        do {
            flights = try await FromJSONAPI.shared.fetchAsyncThrows (nameJSON)
            if  let flightsFromFA = flights  {
                let flightsFA = (flightsFromFA.arrivals)
                + (flightsFromFA.departures )
                + (flightsFromFA.scheduledArrivals )
                + (flightsFromFA.scheduledDepartures)
                await MainActor.run {
                    for flightFA in flightsFA {
                        Flight.update(from: flightFA, in: context)
                    }
                }
            }
        } catch {
            print (" In file \(nameJSON) \(error)")
        }
    }
    //--------------------------------------------------------- Main Actor
    func asyncLoadMainActor () async {
        await airLinesAsync(FilesJSON.airlinesFile)      //-----Airlines
        await airportsAsync(FilesJSON.airportsFile)      //-----Airport
        await flightsAsync(FilesJSON.flightsFileKSFO4)   //-----Flights SFO4
        await flightsAsync(FilesJSON.flightsFileKORD1)   //-----Flights ORD1
    }
    //--------------------------------------------------------------------
}
