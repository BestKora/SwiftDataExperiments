//
//  Airport.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData
import MapKit

@Model final class Airport: Codable{
     @Attribute (.unique) var icao: String
     var name: String = ""
     var city: String = ""
     var state: String = ""
     var countryCode: String = ""
     var latitude: Double = 0.0
     var longitude: Double = 0.0
     var timezone: String = ""
     
     @Relationship (inverse: \Flight.origin) var flightsFrom: [Flight] = []
     @Relationship (inverse: \Flight.destination)  var flightsTo: [Flight] = []
     
     init(icao: String) {
         self.icao = icao
     }
    
    enum CodingKeys: String, CodingKey {
            case airportCode  //  icao
            case name
            case city
            case state
            case countryCode
            case latitude
            case longitude
            case timezone
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.icao = try container.decode(String.self, forKey: .airportCode)
            self.name = try container.decode(String.self, forKey: .name)
            self.city = try container.decode(String.self, forKey: .city)
            self.state = try container.decode(String.self, forKey: .state)
            self.countryCode = try container.decode(String.self, forKey: .countryCode)
            self.latitude = try container.decode(Double.self, forKey: .latitude)
            self.longitude = try container.decode(Double.self, forKey: .longitude)
            self.timezone = try container.decode(String.self, forKey: .timezone)
        }
        
        func encode(to encoder: Encoder) throws {
          // TODO: Handle encoding if you need to here
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

   
