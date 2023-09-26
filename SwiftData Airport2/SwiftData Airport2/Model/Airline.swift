//
//  Airline.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData

@Model final class Airline: Codable {
    /*@Attribute (.unique)*/ var code: String
    var name: String = ""
    var shortname: String = ""
    @Relationship (inverse: \Flight.airline) var flights: [Flight] = []
    
    init(code: String) {
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case icao // code
        case name
        case shortname
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.code = try container.decode(String.self, forKey: .icao)
            self.name = try container.decode(String.self, forKey: .name)
            self.shortname = try container.decode(String?.self, forKey: .shortname) ?? ""
        }
        
        func encode(to encoder: Encoder) throws {
          // TODO: Handle encoding if you need to here
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

    // ----- Calculated atributes ------
    var friendlyName: String { shortname.isEmpty ? name : shortname }
}
