//
//  FlightFromViewModel.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 27/01/2022.
//

import Foundation
import Combine
import SwiftData

struct FilesJSON{
    static var airportsFile = "AIRPORTS"
    static var airlinesFile = "AIRLINES"
    static var flightsFileKSFO4 = "SFO4"
    static var flightsFileKORD1 = "ORD1"
}

final class LoadFlights {
    var context : ModelContext
    var flightsFromFA = FlightsInfo(arrivals: [], departures: [],
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
