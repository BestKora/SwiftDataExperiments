//
//  Model.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 16.06.2023.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer (
            for: [Airport.self, Airline.self, Flight.self],
               ModelConfiguration(inMemory: true)
        )
        // Add in sample data
        SampleData.airportsInsert(context: container.mainContext)
        SampleData.airlinesInsert(context: container.mainContext)
        SampleData.flightsInsert(context: container.mainContext)
        return container
    } catch {
        fatalError("Failed to create preview container")
    }
}()

let previewAirport: Airport = {
    MainActor.assumeIsolated {
        return Airport.withICAO("KSFO", context: previewContainer.mainContext)
    }
} ()

let previewAirline: Airline  = {
    MainActor.assumeIsolated {
        return Airline.withCode ("UAL", context: previewContainer.mainContext)
    }
} ()

struct SampleData {
    static let airports: [Airport] = {
        let airportData1: Airport  = {
            var airport =  Airport(icao: "KSFO")
            airport.latitude = 37.6188056
            airport.longitude = -122.3754167
            airport.name = "San Francisco Int'l"
            airport.city = "San Francisco"
            airport.state = "CA"
            airport.countryCode = "US"
            airport.timezone = "America/Los_Angeles"
            return airport
        } ()
        let airportData2: Airport  = {
            var airport =  Airport(icao: "KJFK")
            airport.latitude = 40.6399278
            airport.longitude = -73.7786925
            airport.name = "John F Kennedy Intl"
            airport.city = "New York"
            airport.state = "NY"
            airport.countryCode = "US"
            airport.timezone = "America/New_York"
            return airport
        } ()
        let airportData3: Airport  = {
            var airport =  Airport(icao: "KPDX")
            airport.latitude = 45.5887089
            airport.longitude = -122.5968694
            airport.name = "Portland Intl"
            airport.city = "Portland"
            airport.state = "OR"
            airport.countryCode = "US"
            airport.timezone = "America/Los_Angeles"
            return airport
        } ()
        
        let airportData4: Airport  = {
            var airport =  Airport(icao: "KSEA")
            airport.latitude = 47.4498889
            airport.longitude = -122.3117778
            airport.name = "Seattle-Tacoma Intl"
            airport.city = "Seattle"
            airport.state = "WA"
            airport.countryCode = "US"
            airport.timezone = "America/Los_Angeles"
            return airport
        } ()
        
        let airportData5: Airport  = {
            var airport =  Airport(icao: "KACV")
            airport.latitude = 40.9778333
            airport.longitude = -124.1084722
            airport.name = "California Redwood Coast-Humboldt County"
            airport.city = "Arcata/Eureka"
            airport.state = "CA"
            airport.countryCode = "US"
            airport.timezone = "America/Los_Angeles"
            return airport
        } ()
        return [airportData1,airportData2, airportData3, airportData4, airportData5]
    }()
    
    static let airlines: [Airline] = {
        let airlineData1: Airline = {
            var airline =  Airline(code: "UAL")
            airline.name = "United Air Lines Inc."
            airline.shortname = "United"
            return airline
        } ()
        
        let airlineData2: Airline = {
            var airline =  Airline(code: "SKW")
            airline.name = "SkyWest Airlines"
            airline.shortname = "SkyWest"
            return airline
        } ()
        
        return [airlineData1, airlineData2]
    }()
    
    static func flightsInsert(context: ModelContext) {
        // -----  1 ----
        let flight = Flight(ident: "UAL1780")
        context.insert(flight)
        flight.origin =  Airport.withICAO("KPDX", context: context)
        flight.destination = Airport.withICAO("KSFO", context: context)
        
        flight.actualOff = ISO8601DateFormatter().date(from:"2022-01-26T16:22:56Z")
        flight.scheduledOff = ISO8601DateFormatter().date(from:"2022-01-26T16:10:00Z")!
        flight.estimatedOff = ISO8601DateFormatter().date(from:"2022-01-26T16:22:56Z")!
        
        flight.scheduledOn = ISO8601DateFormatter().date(from:"2022-01-26T17:13:00Z")!
        flight.estimatedOn = ISO8601DateFormatter().date(from:"2022-01-26T17:41:00Z")!
        //  flight.actualOn = faflight.actualOn
        
        flight.aircraftType = "A319"
        
        flight.progressPercent = 100
        flight.status = "Приземл. / Вырулив."
        flight.routeDistance = 551
        flight.filedAirspeed = 432
        flight.filedAltitude = 350
        flight.airline = Airline.withCode("UAL", context: context)
        
        // -----  2 ----
        let flight1 = Flight(ident: "UAL1541")
        context.insert(flight1)
        flight1.origin =  Airport.withICAO("KSFO", context: context)
        flight1.destination = Airport.withICAO("KSEA", context: context)
        
      //  flight1.actualOff = ISO8601DateFormatter().date(from:"2022-01-26T16:10:00Z")
        flight1.scheduledOff = ISO8601DateFormatter().date(from:"2022-01-26T17:41:00Z")!
        flight1.estimatedOff = ISO8601DateFormatter().date(from:"2022-01-26T17:41:00Z")!
        
        flight1.scheduledOn = ISO8601DateFormatter().date(from:"2022-01-26T18:59:00Z")!
        flight1.estimatedOn = ISO8601DateFormatter().date(from:"2022-01-26T19:18:00Z")!
        //  flight1.actualOn = faflight.actualOn
        
        flight1.aircraftType = "A319"
        
        flight1.progressPercent = 0
        flight1.status = "Вырулив. / Посадка закончена"
        flight1.routeDistance = 680
        flight1.filedAirspeed = 446
        flight1.filedAltitude = 380
        flight1.airline = Airline.withCode("UAL", context: context)
        
        // -----  3 ----
        let flight3 = Flight(ident: "SKW5892")
        context.insert(flight3)
        flight3.origin =  Airport.withICAO("KSFO", context: context)
        flight3.destination = Airport.withICAO("KACV", context: context)
        
        flight3.actualOff    = ISO8601DateFormatter().date(from:"22022-08-25T06:07:15Z")
        flight3.scheduledOff = ISO8601DateFormatter().date(from:"2022-08-25T05:46:00Z")!
        flight3.estimatedOff = ISO8601DateFormatter().date(from:"22022-08-25T06:07:15Z")!
        
        flight3.scheduledOn = ISO8601DateFormatter().date(from:"2022-08-25T06:29:00Z")!
        flight3.estimatedOn = ISO8601DateFormatter().date(from:"2022-08-25T06:48:00Z")!
        //  flight3.actualOn = faflight.actualOn
        
        flight3.aircraftType = "E75L"
        
        flight3.progressPercent = 61
        flight3.status = "В пути / По расписанию"
        flight3.routeDistance = 269
        flight3.filedAirspeed = 413
        flight3.filedAltitude = 260
        flight3.airline = Airline.withCode("SKW", context: context)
    }
    
    static func airportsInsert(context: ModelContext) {
        airports.forEach{context.insert($0)}
    }
    static func airlinesInsert(context: ModelContext) {
        airlines.forEach{context.insert($0)}
    }
}
