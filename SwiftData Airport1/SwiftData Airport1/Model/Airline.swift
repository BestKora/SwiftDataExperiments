//
//  Airline.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData

@Model final class Airline {
  /*  @Attribute (.unique)*/ var code: String
    var name: String
    var shortname: String
    @Relationship (/*deleteRule: .cascade,*/ inverse: \Flight.airline)
    var flights: [Flight]
    
    init(code: String) {
        self.code = code
    }
}

extension Airline {
    
    static func withCode(_ code: String, context: ModelContext) -> Airline {
        // look up code in SwiftData
        let airlinePredicate = #Predicate<Airline> {
            $0.code == code
        }
        let descriptor = FetchDescriptor<Airline>(predicate: airlinePredicate)
        let results = (try? context.fetch(descriptor)) ?? []
        
        // if found, return it
        if let airline = results.first {
            return airline
        } else {
        // if not, create one and fetch from FlightAware
            let airline = Airline(code: code)
            context.insert(airline)
            return airline
        }
    }
    static func update (info: AirlineInfo, context: ModelContext) {
        if !info.icao.isEmpty {
            let code = info.icao 
            let airline = self.withCode(code, context: context)
            airline.name = info.name
            airline.shortname = info.shortname ?? info.callsign
        }
    }
    
    // ----- Calculated atributes ------
    var friendlyName: String { shortname.isEmpty ? name : shortname }
}
