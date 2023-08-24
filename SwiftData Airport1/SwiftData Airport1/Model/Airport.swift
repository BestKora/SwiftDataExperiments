//
//  Airport.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData
import MapKit

@Model final class Airport {
   /* @Attribute (.unique)*/ var icao: String
    var name: String
    var city: String
    var state: String
    var countryCode: String
    var latitude: Double
    var longitude: Double
    var timezone: String
    
    @Relationship (/*deleteRule: .cascade,*/ inverse: \Flight.origin)
                                            var flightsFrom: [Flight]
    @Relationship (/*deleteRule: .cascade, */ inverse: \Flight.destination)
                                            var flightsTo:   [Flight]

    init(icao: String) {
        self.icao = icao
    }
}

extension Airport {
    
    static func withICAO(_ icao: String, context: ModelContext) -> Airport {
        // look up icao in SwiftData
        let airportPredicate = #Predicate<Airport> {
            $0.icao == icao
        }
        let descriptor = FetchDescriptor<Airport>(predicate: airportPredicate)

        let airports = (try? context.fetch(descriptor)) ?? []
        if let airport = airports.first {
            // if found, return it
            return airport
        } else {
            // if not, create one and fetch from FlightAware
            let airport = Airport (icao: icao)
            context.insert(airport )
            return airport
        }
    }
    
    static func update(from info: AirportInfo, context: ModelContext) {
        if !info.airportCode.isEmpty {
            let icao = info.airportCode
            let airport = self.withICAO(icao, context: context)
            airport.latitude = info.latitude
            airport.longitude = info.longitude
            airport.name = info.name
            airport.timezone = info.timezone
            airport.city = info.city
            airport.state = info.state
            airport.countryCode = info.countryCode
        }
    }
    
    //----------- Calculated atribute --------------
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: String {
        return city + " " + state + " " + countryCode
    }
    var friendlyName: String {
        Self.friendlyName(name: name, location: city + " " + (state ))
    }

    static func friendlyName(name: String, location: String) -> String {
        var shortName = name
            .replacingOccurrences(of: " Intl", with: " ")
            .replacingOccurrences(of: " Int'l", with: " ")
            .replacingOccurrences(of: "Intl ", with: " ")
            .replacingOccurrences(of: "Int'l ", with: " ")
        for nameComponent in location.components(separatedBy: ",").map({ $0.trim }) {
            shortName = shortName
                .replacingOccurrences(of: nameComponent, with: " ")
                .replacingOccurrences(of: " " + nameComponent, with: " ")
        }
        shortName = shortName.trim
        shortName = shortName.components(separatedBy: CharacterSet.whitespaces).joined(separator: " ")
        if !shortName.isEmpty {
            return "\(shortName), \(location)"
        } else {
            return location
        }
    }
}

   
