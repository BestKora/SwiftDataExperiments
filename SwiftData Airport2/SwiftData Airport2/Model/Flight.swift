//
//  Flight.swift
//  SwidtData Airport
//
//  Created by Tatiana Kornilova on 21.06.2023.
//

import Foundation
import SwiftData

// MARK: - @Model Flight

@Model final class Flight: Codable {
/* @Attribute (.unique)*/ var ident: String
 var actualOff: Date?
 var scheduledOff: Date = Date()
 var estimatedOff: Date = Date()
 var scheduledOn: Date = Date()
 var estimatedOn: Date = Date()
 var actualOn: Date?
 
 var aircraftType: String = ""
 var progressPercent: Int = 0
 var status: String = ""
 var routeDistance: Int = 0
 var filedAirspeed: Int = 0
 var filedAltitude: Int = 0
 
 var origin: Airport?
 var destination: Airport?
 var airline: Airline?
    
//------- for from JSON ----
 var icaoOrigin: String = ""
 var icaoDestination: String = ""
 var codeAirLine: String = ""
 //--------------------------
 
 init(ident: String) {
     self.ident = ident
 }
    
    // ----- implementation of Codable ---
    enum CodingKeys: String, CodingKey {
        case ident
        case actualOff
        case scheduledOff
        case estimatedOff
        
        case actualOn
        case scheduledOn
        case estimatedOn
        
        case aircraftType
        case progressPercent
        case status
        case routeDistance
        case filedAirspeed
        case filedAltitude
        
        case origin
        case destination
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.ident = try container.decode(String.self, forKey: .ident)
            self.actualOff = try container.decode(Date?.self, forKey: .actualOff)
            self.scheduledOff = try container.decode(Date.self, forKey: .scheduledOff)
            self.estimatedOff = try! container.decode(Date?.self, forKey: .estimatedOff)
                                    ?? self.scheduledOff
            self.actualOn = try container.decode(Date?.self, forKey: .actualOn)
            self.scheduledOn = try container.decode(Date.self, forKey: .scheduledOn)
            self.estimatedOn = try! container.decode(Date?.self, forKey: .estimatedOn) 
                                    ?? self.scheduledOn
            self.aircraftType = try container.decode(String?.self, forKey: .aircraftType) 
                                     ?? "Unknown"
            self.progressPercent = try container.decode(Int.self, forKey: .progressPercent)
            self.status = try container.decode(String.self, forKey: .status)
            self.routeDistance = try container.decode(Int.self, forKey: .routeDistance)
            self.filedAirspeed = try container.decode(Int?.self, forKey: .filedAirspeed) ?? 0
            self.filedAltitude = try container.decode(Int?.self, forKey: .filedAltitude) ?? 0
            let dictionaryOrigin: [String: String?] = 
                     try container.decode(Dictionary<String, String?>.self, forKey: .origin)
            self.icaoOrigin = dictionaryOrigin ["code"]!!
            let dictionaryDestination: [String: String?]  = 
                     try container.decode(Dictionary<String, String?>.self, forKey: .destination)
            self.icaoDestination =  dictionaryDestination["code"]!!
            self.codeAirLine =  String(ident.prefix(while: { !$0.isNumber }))
           
        }
        
        func encode(to encoder: Encoder) throws {
          // TODO: Handle encoding if you need to here
        }
    //---------------------------------------------
}

extension Flight {

    static func withIdent(_ ident: String,  in context: ModelContext) -> Flight {
        // look up ident in SwiftData
        let flightPredicate = #Predicate<Flight> {
            $0.ident == ident
        }
        let descriptor = FetchDescriptor<Flight>(predicate: flightPredicate)
        let results = (try? context.fetch(descriptor)) ?? []
        
        // if found, return it
        if let flight = results.first {
            return flight
        } else {
        // if not, create one
            let flight = Flight(ident: ident)
            context.insert(flight)
            return flight
        }
    }
   
    //----------- Calculated atribute --------------
    var airlineCode: String { String(ident.prefix(while: { !$0.isNumber })) }
    
    var duration: Double {Double(Int(estimatedOn.timeIntervalSince(estimatedOff))) / 3600.0}
    var durationTime: Measurement<UnitDuration> {Measurement(value: duration,
                                                             unit: UnitDuration.hours)}
    
    // ---------- Distance and Speed полета по приборам (ППП)
    var distance: Measurement<UnitLength> {Double(routeDistance).convert(from: .miles,
                                                                         to: .kilometers)}
    var distanceInKm: String {distance.format()}
    var speedInKmHours: String {Double(filedAirspeed).convert(from: .knots,
                                                              to: .kilometersPerHour).format()}
    var distanceAndSpeed: String {"distance = " + distanceInKm + "   speed = " + speedInKmHours}
    
    // ----------Длительность полета и средняя скорость полета ------------
    var durationHoursMin: String {estimatedOn.timeIntervalSince(estimatedOff).hourMinuteUnit}
    var averageSpeed:String { (distance / durationTime).converted(to: .kilometersPerHour).format()}
    var hoursAndSpeed: String {durationHoursMin +  "    aveSpeed = " + averageSpeed}
    
    var depature: Date {actualOff ?? estimatedOff}
    var arrival: Date {actualOn ?? estimatedOn}
    
    //-------------------- Status----------------------------------
    var statusShort: String {
        if status.components(separatedBy: "/") .count > 1 {
           let status1 = status.components (separatedBy: "/")[0] == " В пути"
            ?
            status.components(separatedBy: "/")[1]
            :
            status.components(separatedBy: "/")[1]
            if status1.contains(elementIn: ["Прил."]){
                return status1.components (separatedBy: "Прил.")[1]
            } else {
                return status1
            }
        } else {
            return status
        }
    }
}

// MARK: - FlightsCodable
class FlightsCodable: Codable {
    let arrivals:  [Flight]
    let departures:  [Flight]
    let scheduledArrivals:[Flight]
    let scheduledDepartures: [Flight]
        
    enum CodingKeys: String, CodingKey {
        case arrivals
        case departures
        case scheduledArrivals
        case scheduledDepartures
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.arrivals = try container.decode([Flight].self, forKey: .arrivals)
            self.departures = try container.decode([Flight].self, forKey: .departures)
            self.scheduledArrivals = try container.decode([Flight].self, forKey: .scheduledArrivals)
            self.scheduledDepartures = try container.decode([Flight].self, forKey: .scheduledDepartures)
        }
        
        func encode(to encoder: Encoder) throws {
          // TODO: Handle encoding if you need to here
        }
}
